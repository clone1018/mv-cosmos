defmodule World.Endpoints.MapEndpoints do

  def map_enter(state, map_id, game_id, player_id) do
    {state, {}}
  end

  # characterIndex, characterName, direction, moveSpeed, moveFrequency
  def spawn(state, map_id, player_id, x, y) do
    {:ok, _} = World.MapSupervisor.find_or_create_process(map_id)

    {state, {}}
  end

  def despawn(state) do
    {state, {}}
  end

  def move(state, map_id, player_id, x, y, direction, moveSpeed, moveFrequency) do
    World.Player.update_position(player_id, map_id, x, y)

    {state, {}}
  end

end
