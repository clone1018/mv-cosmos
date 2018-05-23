defmodule World do
  use Application

  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: World.Http.Router,
        options: [port: 8101, dispatch: World.Http.Router.dispatch_table()]
      )
    ]

    Logger.info("Started World Server")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: World.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
