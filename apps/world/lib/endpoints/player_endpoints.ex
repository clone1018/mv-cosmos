defmodule World.Endpoints.PlayerEndpoints do

  def connect(state, game_id, player_id) do
    result =
      case World.Repo.get(World.Player, game_id) do
        nil  -> %World.Player{id: game_id}
        player -> player
      end
      |> World.Player.changeset
      |> World.Repo.insert_or_update

    state = Map.put(state, :player_id, game_id)

    {state, {}}
  end

  def refresh(state, player_id, character_index, character_name) do
    player = World.Player |> World.Repo.get(player_id)

    changeset = World.Player.changeset(player, %{
      character_index: character_index,
      character_name: character_name
    })
    {:ok, _person} = World.Repo.update(changeset)

    {state, {}}
  end

end
