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
```
in elx020_sup_app\lib\elx020_sup_app\application.ex we add supervisor and workers
```elixir
opts = [strategy: :one_for_one, name: Elx020SupApp.Supervisor]
```

## Try it out - run it
Run, stop workers, exit

## Add genserver
We want a genserver as the worker for ???



# HowTos
* [Elixir Project Scaffolding](chats/elixir_erlang_mix_chat.md)
* [GenServer + Supervision for AI Agents in Elixir](chats/elixir-genserver-ai-agents.md)

# Tools
* [Erlang package registry](https://hex.pm/) - Like Like NPMjs.com
* [igniter](https://hex.pm/packages/igniter) - A code generation and project patching framework

---
