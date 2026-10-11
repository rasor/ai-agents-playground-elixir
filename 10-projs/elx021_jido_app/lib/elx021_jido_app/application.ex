defmodule Elx021JidoApp.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Elx021JidoApp.Jido]

    opts = [strategy: :one_for_one, name: Elx021JidoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
