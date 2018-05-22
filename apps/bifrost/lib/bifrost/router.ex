defmodule Bifrost.Router do
  use Plug.Router
  use WebSocket


  plug Plug.Logger

  # WebSocket routes
  #      route     controller/handler     function & name
  socket "/",  Bifrost.Http.EchoController,  :echo

  plug :match
  plug :dispatch

  # Rest of your router's plugs and routes
  # ...

  def run(opts \\ []) do
    dispatch = dispatch_table(opts)
    Plug.Adapters.Cowboy.http __MODULE__, opts, [dispatch: dispatch]
  end


  match _ do
    send_resp(conn, 200, "Hello from plug")
  end
end
