[GenServer supervision for AI agents in Elixir](https://claude.ai/chat/80cf162b-f17c-4d5a-8eae-18d47a2bdfe9)
# Prompt
* In elixir how do I use genserver to ‘add supervision an go’, so that I can use it for running ai-agents?
  * what code do I need?
  * how do I start it in my local pc?
    * how do I log?
    * how do I debug it?
   * how do I stop it?
  * how do I write deploy yaml for azure devops?
    * what iac script is needed before that?
    * how do I start it in azure?
    * how do I stop it in azure?
    * how do I read logs in azure?
    
# GenServer + Supervision for AI Agents in Elixir

## 1. The Code

**Agent GenServer** (`lib/my_app/agents/agent_server.ex`):

```elixir
defmodule MyApp.Agents.AgentServer do
  use GenServer
  require Logger

  # --- Client API ---
  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  def run_task(name, task), do: GenServer.call(via_tuple(name), {:run_task, task}, 30_000)
  def get_state(name), do: GenServer.call(via_tuple(name), :get_state)
  def stop(name), do: GenServer.stop(via_tuple(name), :normal)

  defp via_tuple(name), do: {:via, Registry, {MyApp.AgentRegistry, name}}

  # --- Server Callbacks ---
  @impl true
  def init(opts) do
    Logger.info("Agent starting", agent: opts[:name])
    {:ok, %{name: opts[:name], history: [], status: :idle}}
  end

  @impl true
  def handle_call({:run_task, task}, _from, state) do
    Logger.info("Running task", agent: state.name, task: inspect(task))
    result = do_run(task, state)
    {:reply, {:ok, result}, %{state | history: [task | state.history]}}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp do_run(task, _state) do
    # call your LLM/tool logic here
    {:done, task}
  end
end
```

**Registry + DynamicSupervisor** (`lib/my_app/agents/supervisor.ex`):

```elixir
defmodule MyApp.Agents.Supervisor do
  use DynamicSupervisor

  def start_link(_), do: DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_agent(name) do
    spec = {MyApp.Agents.AgentServer, name: name}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_agent(name) do
    case Registry.lookup(MyApp.AgentRegistry, name) do
      [{pid, _}] -> DynamicSupervisor.terminate_child(__MODULE__, pid)
      [] -> {:error, :not_found}
    end
  end
end
```

**Application supervision tree** (`lib/my_app/application.ex`):

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: MyApp.AgentRegistry},
      MyApp.Agents.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

This gives you: restart-on-crash via `one_for_one`, named lookup via `Registry`, and dynamic add/remove of agents at runtime.

---

## 2. Running Locally

```bash
mix deps.get
iex -S mix
```

In IEx:
```elixir
MyApp.Agents.Supervisor.start_agent("agent-1")
MyApp.Agents.AgentServer.run_task("agent-1", %{prompt: "hello"})
```

### Logging
Configure in `config/config.exs`:
```elixir
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:agent, :task]

config :logger, level: :debug
```
Use `require Logger; Logger.info/debug/warning/error` inside the GenServer as shown above.

### Debugging
- `:observer.start()` in IEx — visual process tree, mailbox sizes, state inspection.
- `:sys.get_state(pid_or_name)` — dump GenServer state live.
- `:sys.trace(pid, true)` — trace all messages in/out.
- `IEx.pry()` inside a callback + run with `iex -S mix` then trigger the call from another shell tab (`Node.connect` or just same node).
- `Process.whereis` / `Registry.lookup` to find pids from names.

### Stopping
```elixir
MyApp.Agents.Supervisor.stop_agent("agent-1")   # single agent
# or Ctrl+C twice / Ctrl+G, q in IEx to kill the whole VM
```

---

## 3. Azure DevOps Deployment

### IaC first (Terraform example, minimal)

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-myapp"
  location = "westeurope"
}

resource "azurerm_service_plan" "plan" {
  name                = "asp-myapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "myapp-agents"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name = "myapp-agents:latest"
    }
  }

  app_settings = {
    MIX_ENV = "prod"
  }
}
```

Run once (or in a pipeline stage) via `terraform init && terraform plan && terraform apply`.

Since Elixir/BEAM apps aren't natively supported on App Service, package as a **Docker container** — build a release with `mix release`, wrap in a minimal Dockerfile, push to Azure Container Registry.

### azure-pipelines.yml

```yaml
trigger:
  - main

variables:
  acrName: 'myappacr'
  imageName: 'myapp-agents'

stages:
- stage: Build
  jobs:
  - job: BuildAndPush
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'myACRServiceConnection'
        repository: '$(imageName)'
        command: 'buildAndPush'
        Dockerfile: 'Dockerfile'
        tags: '$(Build.BuildId)'

- stage: Deploy
  dependsOn: Build
  jobs:
  - job: DeployToAppService
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: AzureWebAppContainer@1
      inputs:
        azureSubscription: 'myAzureServiceConnection'
        appName: 'myapp-agents'
        containers: '$(acrName).azurecr.io/$(imageName):$(Build.BuildId)'
```

### Start in Azure
Deployment (above) auto-starts the container. Manually: Azure Portal → App Service → **Start**, or CLI:
```bash
az webapp start --name myapp-agents --resource-group rg-myapp
```

### Stop in Azure
```bash
az webapp stop --name myapp-agents --resource-group rg-myapp
```

### Read logs in Azure
```bash
az webapp log tail --name myapp-agents --resource-group rg-myapp
```
Or enable persistent logging first:
```bash
az webapp log config --name myapp-agents --resource-group rg-myapp --docker-container-logging filesystem
```
Portal alternative: App Service → **Log stream**, or **Diagnose and solve problems** → Application Logs.
