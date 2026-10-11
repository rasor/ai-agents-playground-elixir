
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
        * Jido.Signal [16:45](https://youtu.be/qi0Hl_RSbAU?t=1006)
          * Based off cloud events.
          * soure // event from where?
        * Jido.Action [18:01](https://youtu.be/qi0Hl_RSbAU?t=1081)
          * Commands
          * run() with list of parms and context, returns ok or err tuple. Schema for parms.
          * compat with LLM tool call
          * A workflow is an action that call a workflow
          * An agent calls an action using exec(), which wraps the action in timeouts, in async etc
          * When design an agent list the actions it needs to do.
        * SDK [21:24](https://youtu.be/qi0Hl_RSbAU?t=1284)
          * call any LLM
          * Modelled of [Vercel SDK](https://vercel.com/ai-sdk)
          * are awailable as actions - e.g. GenerateText.run()
          * Jido was designed as an SDK
        * Create a stateless agent [23:42](https://youtu.be/qi0Hl_RSbAU?t=1422)
          * An agent is a data struct having
            * schema of data the agent should hold and // validated at runtime
            * its allowed actions
          * Use agent [25:38](https://youtu.be/qi0Hl_RSbAU?t=1538)
        * Stateful agent [28:46](https://youtu.be/qi0Hl_RSbAU?t=1726)
          * GenServer comes into the mix. Agent is embedded into it.
          * Through messages/signals interact using
            * call or // returns the agent itself
            * cast
        * Demo: Calculator Agent [31:40](https://youtu.be/qi0Hl_RSbAU?t=1900)

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

```bash
cd..
# Scaffold a elixir project
mix new elx021b_jido_app
cd elx021b_jido_app
mix test

mix archive.install hex igniter_new
# Add jido deps to mix.exs
mix igniter.install jido
#mix igniter.install jido_ai,jido_action,jido_signal
mix test
```
once more warnings - missing lua, Phoenix.PubSub and public_key. And Extension registry
```bash
# warning: Lua.new/1 is undefined (module Lua is not available or is yet to be defined). Make sure the module name is correct and has been specified in full (or that an alias has been defined)
# 14:46:35.086 [debug] Extension registry unavailable queued module=Jido.Signal.Ext.Trace
# warning: Phoenix.PubSub.broadcast/3 is undefined (module Phoenix.PubSub is not available or is yet to be defined)
# warning: :public_key.cacerts_get/0 is undefined (module :public_key is not available or is yet to be defined)
```
Lets try again
```bash
cd..
# Scaffold a elixir project
mix new elx021_jido_app
cd elx021_jido_app
mix test

mix archive.install hex igniter_new
# Add deps to mix.exs
mix igniter.install lua
mix test
mix igniter.install phoenix_pubsub
mix test
mix igniter.install jido
# You are installing the package "jido":
# Description:       An autonomous agent framework for Elixir, built for workflows and multi-agent systems.
# Current version:   2.4.0 (released 2026-10-08)
# hex.pm authors:    mikehostetler
# hex.pm publishers: mikehostetler
# Dependencies:      crontab, igniter, jido_action, jido_signal, nimble_options, poolboy, splode, telemetry, telemetry_metrics, time_zone_info, zoi
# Downloads:         551 (this version), 17 675 (last 7 days), 215 799 (all time)
mix test
```
now only these warnings:
```
15:26:54.898 [debug] Extension registry unavailable queued module=Jido.Signal.Ext.Trace
warning: :public_key.cacerts_get/0 is undefined (module :public_key is not available or is yet to be defined)
```
In `mix.exs` changed 
`      extra_applications: [:logger],`
to 
`      extra_applications: [:logger, :public_key],`
Now `mix test` does not complain.  

---
I noticed that `application.ex` reveals that a supervisor has been installed:  
`Supervisor.start_link(children, opts)`  

Seemingly also `jido_action` and `jido_signal` was installed.  

So perhaps now we can install the `jido_ai` module?

```bash
mix igniter.install jido_ai
# You are installing the package "jido_ai":
# Description:       AI integration layer for the Jido ecosystem - Actions, Workflows, and LLM orchestration
# Current version:   2.4.0 (released 2026-10-09)
# hex.pm authors:    mikehostetler
# hex.pm publishers: mikehostetler
# Dependencies:      fsmx, igniter, jason, jido, jido_action, req_llm, splode, yaml_elixir, zoi
# Downloads:         302 (this version), 15 191 (last 7 days), 114 701 (all time)

# * Jido AI installed successfully!
#   Next steps:
#     1. Configure your LLM provider API keys:
  
#        # config/runtime.exs
#        config :req_llm,
#          anthropic_api_key: System.get_env("ANTHROPIC_API_KEY"),
#          openai_api_key: System.get_env("OPENAI_API_KEY")
#     2. Check out the getting started guide:
#        https://hexdocs.pm/jido_ai/readme.html

mix test
# still gives warnings - perhaps live with them for now?

# 16:14:33.984 [debug] Extension registry unavailable queued module=Jido.Signal.Ext.Trace
# 16:14:34.023 [debug] Extension registry unavailable queued module=Jido.Signal.Ext.Dispatch
#      warning: :public_key.cacerts_get/0 is undefined (module :public_key is not available or is yet to be defined)
#      warning: :public_key.pkix_verify_hostname_match_fun/1 is undefined (module :public_key is not available or is yet to be defined)
```