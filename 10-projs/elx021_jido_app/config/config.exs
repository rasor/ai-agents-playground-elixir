import Config

config :jido_ai,
  model_aliases: %{
    capable: "anthropic:claude-sonnet-4-20250514",
    fast: "anthropic:claude-haiku-4-5"
  }

config :elx021_jido_app, Elx021JidoApp.Jido, max_tasks: 1000, agent_pools: []
