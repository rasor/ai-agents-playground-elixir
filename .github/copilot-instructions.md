<!-- Created with copilot /init -->

# Copilot instructions for this repository

This repository is a small Elixir learning/playground repo, not a single production application. The important unit of work is each app under `10-projs/`, and each app is its own Mix project.

## Repo layout and app model

- Root-level folders such as `00-readme/` hold notes and setup guides.
- Exercise apps live under `10-projs/`.
- The active project in this repo is currently `10-projs/elx021_jido_app`, which is a Jido-based Elixir app.
- There is no root-level `mix.exs` for the whole repository; run commands inside the specific app directory you are changing.

## Build, test, and formatting commands

From the target app directory:

```bash
cd 10-projs/elx021_jido_app
mix deps.get
mix compile
mix test
mix test test/elx021_jido_app_test.exs
mix format
mix format --check-formatted
```

Common patterns in this repo:

- Use `mix test` for the full suite in the active app.
- Use `mix test path/to/file_test.exs` for a single test file.
- Use `mix test --seed 0 test/...` when you need deterministic failures or reproductions.
- If dependencies are missing, run `mix deps.get` before compiling or testing.

## High-level architecture

Each app follows the standard Elixir/Mix OTP layout:

- `mix.exs` defines the app, version, Elixir version, and dependencies.
- `lib/<app_name>.ex` contains the public module entry point and example API surface.
- `lib/<app_name>/application.ex` defines the OTP `Application` and starts the supervision tree.
- `lib/<app_name>/jido.ex` is a thin Jido integration layer, using `use Jido, otp_app: :<app_name>` to register the app as a Jido runtime.
- `config/` holds runtime configuration for the app.
- `test/` contains ExUnit tests for the app.

The Jido example in this repo is intentionally lightweight: the supervisor starts the Jido process tree, while the behavior-specific logic is organized around the Jido module rather than a large framework layer.

## Key conventions in this codebase

- Keep exercise apps isolated under `10-projs/<app_name>` rather than mixing multiple projects at the repo root.
- Prefer app-local commands over repo-root commands; each app has its own Mix project and dependency set.
- Follow the default Elixir OTP pattern: `Application` starts child processes, and `Supervisor` coordinates them.
- For Jido work, treat the Jido module as the runtime boundary and keep app-specific logic close to the module that uses `use Jido`.
- The repo includes notes and setup docs under `00-readme/`; when a new feature or refactor depends on an earlier exercise, check those docs before making assumptions about intended behavior.
- Keep code idiomatic Elixir and rely on standard Mix conventions (`mix format`, `ExUnit`, OTP supervision) rather than introducing project-level custom tooling.

## Relevant project history

The setup notes in `00-readme/021-create-ex-jido-proj.md` show that this repo is intentionally exploring Jido and related Elixir AI-agent tooling. The project history also documents the dependency pattern used for these examples:

- `jido`
- `jido_ai`
- `lua`
- `phoenix_pubsub`
- `:public_key` in `extra_applications` when required by the runtime

When adding or changing dependencies, keep them aligned with the app’s Mix project, not the repo root.
