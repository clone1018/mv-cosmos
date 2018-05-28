defmodule World.Endpoints.MapEndpoints do

  def map_enter(state, map_id, game_id, player_id) do
    {state, {}}
  end

  # characterIndex, characterName, direction, moveSpeed, moveFrequency
  def spawn(state, player_id, map_id, x, y) do
    player = World.Player |> World.Repo.get(player_id)

    changeset = World.Player.changeset(player, %{
      map_id: map_id,
      x: x,
      y: y
    })
    {:ok, _person} = World.Repo.update(changeset)

    {state, {}}
  end

  def despawn(state) do
    {state, {}}
  end

  def move(state, player_id, map_id, x, y, direction, move_speed, move_frequency) do
    player = World.Player |> World.Repo.get(player_id)

    changeset = World.Player.changeset(player, %{
      x: x,
      y: y,
      direction: direction,
      move_speed: move_speed,
      move_frequency: move_frequency
    })
    {:ok, _person} = World.Repo.update(changeset)

    {state, {}}
  end

end
