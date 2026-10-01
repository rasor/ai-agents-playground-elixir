
## Jido Ecosystem
[![Jido Ecosystem](img/021-jido-ecosystem.png)](https://jido.run/ecosystem)

* [AI agents on Erlang/OTP runtime](chats/erlang-otp-ai-agent-frameworks.md)
  * github: [jido](https://github.com/agentjido/jido)
  * github: [jido_ai](https://github.com/agentjido/jido_ai)
  * vid: [Jido: An introduction to Autonomous Agents with Elixir - Elixir Montreal (2025-08)](https://www.youtube.com/watch?v=qi0Hl_RSbAU)
    * Sense, plan, act
      * Sense: Gather data
      * Plan: Decide what todo based on current state
      * Act: execute decision
      * Loop
    * ETL
      * Extract: Fetch data
      * Transform: Process, analyse (use LLMs)
      * Load: Output or take actions
    * Elixir
      * Actor Model Alignment
        * Processes for agent components
        * Messages for inter-agent communication
      * Fault Tolerance
        * Supervision trees
        * crach for self-healing agents
      * Concurrency
        * Millions of processes/agents - in cloud often a docker container for an agent
        * No shared state concerns - state is sent in messages
      * Jido
        * based of Eliza OS - an LLM that could respond or take action on your behalf, with community plugins
        * Philosophy
          * Datadriven
          * No magic: Explcit, inspectable operations
          * Ecosystem-first: Composable, Extensionpoints
          * You don't need LLMs for agents
        * Install [16:00](https://youtu.be/qi0Hl_RSbAU?si=kqWMUJKBUe6kZRdN&t=964)
          * https://jido.run/ecosystem
          * https://github.com/agentjido/jido // Runtime
          * https://github.com/agentjido/jido_ai // Agents
          * https://github.com/agentjido/req_llm // LLM
          * https://github.com/agentjido/jido_action // operations/methods having swagger-like documentation
          * https://github.com/agentjido/jido_signal // message structure, reliable pub/sub bus

## Scaffold
We can scaffold elixir.  
```bash
# Scaffold a elixir project
mix new elx021_jido_app
cd elx021_jido_app
mix test

mix archive.install hex igniter_new
# Add jido deps to mix.exs
mix igniter.install jido,jido_ai,jido_action,jido_signal
# checking for igniter in project ✔
# Updating project's igniter dependency ✔
# compiling igniter ✔
# setting up igniter ✔

# You are installing the package "jido":
# You are installing the package "jido_ai":
# You are installing the package "jido_action":
# You are installing the package "jido_signal":
# Update: mix.exs
# Modify mix.exs and install?
# == Type checking failed with errors ==
# could not compile dependency :jido_signal, "mix compile" failed. Errors may have been logged above. You can recompile this dependency with "mix deps.compile jido_signal --force", update it with "mix deps.update jido_signal" or clean it with "mix deps.clean jido_signal"
```
...hmm troubles - guess I'll have to start with only to install jido...

