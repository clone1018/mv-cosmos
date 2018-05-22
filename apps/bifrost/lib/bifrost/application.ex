defmodule Bifrost.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Bifrost.Router, options: [port: 4000, dispatch: Bifrost.Router.dispatch_table])
    ]

    Logger.info("Started application")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bifrost.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
