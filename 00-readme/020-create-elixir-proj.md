# Create an elixir project with a supervisor and a genserver

## Scaffold
We can scaffold a supervisor to manage a worker with the genserver.  
The worker is not yet created.  
```bash
# Scaffold a elixir project with a supervisor
mix new elx020_sup_app --sup
# * creating README.md
# * creating .formatter.exs
# * creating .gitignore
# * creating mix.exs // project file
# * creating lib
# * creating lib/elx020_sup_app.ex // A static function
# * creating lib/elx020_sup_app/application.ex // supervisor and workers
# * creating test
# * creating test/test_helper.exs
# * creating test/elx020_sup_app_test.exs

# Your Mix project was created successfully.
# You can use "mix" to compile it, test it, and more
# Run "mix help" for more commands.

cd elx020_sup_app

mix test
# Compiling 2 files (.ex)
# Generated elx020_sup_app app
# Running ExUnit with seed: 689142, max_cases: 16
# Finished in 0.06 seconds (0.00s async, 0.06s sync)
# Result: 2 passed (1 doctest, 1 test)

# what else can we do with mix?
mix help
# mix                        # Runs the default task (current: "mix run")
# mix app.config             # Configures all registered apps
# mix app.start              # Starts all registered apps
# mix app.tree               # Prints the application tree
# mix archive                # Lists installed archives
# mix archive.build          # Archives this project into a .ez file
# mix archive.install        # Installs an archive locally
# mix archive.uninstall      # Uninstalls archives
# mix clean                  # Deletes generated application files
# mix cmd                    # Executes the given command
# mix compile                # Compiles source files
# mix deps                   # Lists dependencies and their status
# mix deps.clean             # Deletes the given dependencies' files
# mix deps.compile           # Compiles dependencies
# mix deps.get               # Fetches unavailable and out of date dependencies
# mix deps.tree              # Prints the dependency tree
# mix deps.unlock            # Unlocks the given dependencies
# mix deps.update            # Updates the given dependencies
# mix do                     # Executes the tasks separated by plus
# mix escript                # Lists installed escripts
# mix escript.build          # Builds an escript for the project
# mix escript.install        # Installs an escript locally
# mix escript.uninstall      # Uninstalls escripts
# mix eval                   # Evaluates the given code
# mix format                 # Formats the given files/patterns
# mix help                   # Prints help information for tasks, aliases, modules, and applications
# mix hex                    # Prints Hex help information
# mix hex.audit              # Shows retired Hex deps and security advisories for the current project
# mix hex.build              # Builds a new package version locally
# mix hex.config             # Reads, updates or deletes local Hex config
# mix hex.docs               # Fetches or opens documentation of a package
# mix hex.info               # Prints Hex information
# mix hex.organization       # Manages Hex.pm organizations
# mix hex.outdated           # Shows outdated Hex deps for the current project
# mix hex.owner              # Manages Hex package ownership
# mix hex.package            # Fetches, diffs, or searches packages
# mix hex.policy             # Inspects the active Hex dependency policy
# mix hex.publish            # Publishes a new package version
# mix hex.registry           # Manages local Hex registries
# mix hex.repo               # Manages Hex repositories
# mix hex.retire             # Retires a package version
# mix hex.search             # Open and perform documentation search
# mix hex.sponsor            # Show Hex packages accepting sponsorships
# mix hex.user               # Manages your Hex user account
# mix igniter.add            # Adds the provided deps to `mix.exs`
# mix igniter.apply_upgrades # Applies the upgrade scripts for the list of package version changes provided.
# mix igniter.init_library   # Set up a library to use Igniter. Adds the optional dependency and an install task.
# mix igniter.install        # Install a package or packages, and run any associated installers.
# mix igniter.new            # Creates a new Igniter application
# mix igniter.remove         # Removes the provided deps from `mix.exs`
# mix igniter.upgrade        # Fetch and upgrade dependencies. A drop in replacement for `mix deps.update` that also runs upgrade tasks.
# mix loadconfig             # Loads and persists the given configuration
# mix local                  # Lists tasks installed locally via archives
# mix local.hex              # Installs Hex locally
# mix local.igniter          # Updates the Igniter project generator locally
# mix local.rebar            # Installs Rebar locally
# mix new                    # Creates a new Elixir project
# mix profile.cprof          # Profiles the given file or expression with cprof
# mix profile.eprof          # Profiles the given file or expression with eprof
# mix profile.fprof          # Profiles the given file or expression with fprof
# mix profile.tprof          # Profiles the given file or expression with tprof
# mix release                # Assembles a self-contained release
# mix release.init           # Generates sample files for releases
# mix run                    # Runs the current application
# mix source                 # Prints source location for modules and functions
# mix test                   # Runs a project's tests
# mix test.coverage          # Build report from exported test coverage
# mix xref                   # Prints cross reference information
# iex -S mix                 # Starts IEx and runs the default task // REPL

# Use "mix help <TASK>" for more information on a particular command.
```
in elx020_sup_app\lib\elx020_sup_app\application.ex we add supervisor and workers
```elixir
opts = [strategy: :one_for_one, name: Elx020SupApp.Supervisor]
```

## Try it out - run it
Run, stop workers, exit

### Run and stop
```bash
mix compile.app
# Generated elx020_sup_app app

# downlad dependensies
mix deps.get
# start elixir shell/REPL - interactive elixir
iex -S mix
```

In IEx:
```elixir
Elx020SupApp.Agents.Supervisor.start_agent("agent-1")
Elx020SupApp.Agents.AgentServer.run_task("agent-1", %{prompt: "hello"})
```

Stopping
```elixir
Elx020SupApp.Agents.Supervisor.stop_agent("agent-1")   # single agent
# or Ctrl+C twice / Ctrl+G, q in IEx to kill the whole VM
```

## Add genserver
We want a genserver as the worker for [agents](chats/elixir-genserver-ai-agents.md)


# HowTos
* [Elixir Project Scaffolding](chats/elixir_erlang_mix_chat.md)
* [GenServer + Supervision for AI Agents in Elixir](chats/elixir-genserver-ai-agents.md)

# Tools
* [Erlang package registry](https://hex.pm/) - Like Like NPMjs.com
* [igniter](https://hex.pm/packages/igniter) - A code generation and project patching framework

# Refs
* School: [Elixir School](https://elixirschool.com/en)
* Docs: [Supervisor](https://elixir.hexdocs.pm/Supervisor.html)
  * School: [Supervisors](https://elixirschool.com/en/lessons/advanced/otp_supervisors)
  * [Dynamic supervisors](https://elixir.hexdocs.pm/dynamic-supervisor.html#dynamic-supervisors)
* Docs: [GenServer](https://elixir.hexdocs.pm/GenServer.html)
  * [Client-server with GenServer](https://elixir.hexdocs.pm/genservers.html)
* Docs: [Debugging](https://elixir.hexdocs.pm/debugging.html)
  * School: [Debugging](https://elixirschool.com/en/lessons/misc/debugging)
* School: [Error_handling](https://elixirschool.com/en/lessons/intermediate/error_handling) - including IO.puts
  * Docs: [Other tools](https://elixir.hexdocs.pm/debugging.html#other-tools-and-community)
  * Book: [Erlang in anger](https://www.erlang-in-anger.com/)
* Book: [Learn You Some Erlang for great good!](https://learnyousomeerlang.com/)

---
