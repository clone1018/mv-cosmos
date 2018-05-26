defmodule World.Endpoints.MapEndpoints do

  def map_enter(state, game_id, player_id) do

  end

  # characterIndex, characterName, direction, moveSpeed, moveFrequency
  def spawn(map_id, player_id, x, y) do
    {:ok, _} = World.Map.start_link(map_id)

    World.Map.add_player
  end

  def despawn(state) do

  end

  def move(map_id, player_id, x, y, direction, moveSpeed, moveFrequency) do

  end

end
