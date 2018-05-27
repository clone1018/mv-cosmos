defmodule World.Endpoints.PlayerEndpoints do

  def connect(state, game_id, player_id) do
    {:ok, _pid} = World.PlayerSupervisor.find_or_create_process(game_id)

    state = Map.put(state, :player_id, game_id)

    {state, {}}
  end

end
