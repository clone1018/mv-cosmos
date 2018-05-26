defmodule World.PlayerManager do

  def connect(state, game_id, player_id) do
    {:ok, _pid} = World.Player.start_link(game_id)

    state = Map.put(state, :player_id, game_id)

    {state, {}}
  end

end
