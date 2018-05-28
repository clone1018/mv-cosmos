defmodule World.Http.WebsocketRouter do
  require Logger

  def handle(:init, state) do
    state = %{state | use_topics: false}
    ip_addr = state.conn.remote_ip |> :inet.ntoa() |> to_string()
    Logger.info("New client connection from " <> ip_addr)
    {:ok, state}
  end

  def handle(:terminate, _state) do
    Logger.info("Ended client connection")
    :ok
  end

  def handle(message, state) do
    ip_addr = state.conn.remote_ip |> :inet.ntoa() |> to_string()
    Logger.debug("Incoming: " <> message <> " from " <> ip_addr)

    # This is essentially our temporary router, based on the int passed
    # by the client, route to a specific action, pass tail end into function
    action_list = %{
      0 => [World.Endpoints.PlayerEndpoints, :connect],
      1 => [World.Endpoints.MapEndpoints, :map_enter],
      2 => [World.Endpoints.MapEndpoints, :spawn],
      3 => [World.Endpoints.MapEndpoints, :despawn],
      4 => [World.Endpoints.MapEndpoints, :move],
      5 => [World.Endpoints.PlayerEndpoints, :refresh]
    }

    {:ok, parsed} = Poison.decode(message)

    [module, method] = Map.fetch!(action_list, hd(parsed))
    {state, out} = apply(module, method, [state] ++ tl(parsed))

    # self() or state.conn.owner
    # :ok = WebSocket.Events.broadcast(:handle, {:text, message}, self())

    #{:reply, {:text, message}, state}
    {:reply, {:text, "{}"}, state}
  end
end
