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
    Logger.debug("Incoming: " <> message)

    # This is essentially our temporary router, based on the int passed
    # by the client, route to a specific action, pass tail end into function
    action_list = %{
      0 => [Account.PlayerManager, :connect],
      1 => [World.MapManager, :map_enter],
      2 => [World.MapManager, :spawn],
      3 => [World.MapManager, :despawn],
      4 => [World.MapManager, :move]
    }

    {:ok, parsed} = Poison.decode(message)

    [module, method] = action_list[hd(parsed)]
    apply(module, method, tl(parsed))
  end
end
