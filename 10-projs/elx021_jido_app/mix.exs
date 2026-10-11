defmodule Elx021JidoApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :elx021_jido_app,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :public_key],
      mod: {Elx021JidoApp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jido_ai, "~> 2.0"},
      {:jido, "~> 2.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:lua, "~> 1.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
