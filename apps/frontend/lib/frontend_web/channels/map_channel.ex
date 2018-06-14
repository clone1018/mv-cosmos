defmodule FrontendWeb.MapChannel do
  use Phoenix.Channel

  # def join("room:lobby", message, socket) do
  #   IO.inspect(message)
  #   {:ok, socket}
  # end
  def join("map:" <> map_id, _params, socket) do
    map_id = map_id |> String.to_integer
    socket = Map.put(socket, :map_id, map_id)

    if World.MapSupervisor.map_process_exists?(map_id) do

      player = World.Player |> World.Repo.get(socket.assigns.player_id)

      changeset = World.Player.changeset(player, %{
        map_id: map_id,
        x: 0,
        y: 0,
        direction: 0,
        move_speed: 0,
        move_frequency: 0,
        character_index: 1,
        character_name: "Actor1"
        })
      {:ok, _person} = World.Repo.update(changeset)

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("SPAWN", %{"x" => x, "y" => y} = coords, socket) do
    otherPlayersOnMap = World.Player |> World.Player.on_map(socket.map_id) |> World.Repo.all

    Enum.each(otherPlayersOnMap, fn(player) ->
      push(socket, "EXIST", %{
        player_id: player.id,
        x: player.x,
        y: player.y,
        direction: player.direction,
        move_speed: player.move_speed,
        move_frequency: player.move_frequency,
        character_index: player.character_index,
        character_name: player.character_name
      })
    end)

    broadcast!(socket, "SPAWN", coords |> Map.put("player_id", socket.assigns.player_id))

    {:noreply, socket}
  end

  def handle_in("DESPAWN", %{"x" => x, "y" => y} = coords, socket) do
    players = World.Player |> World.Player.on_map(socket.map_id) |> World.Repo.all
#
#    Enum.each(players, fn(player) ->
#      push(socket, "EXIST", %{
#        player_id: player.id,
#        x: player.x,
#        y: player.y,
#        direction: player.direction,
#        move_speed: player.move_speed,
#        move_frequency: player.move_frequency,
#        character_index: player.character_index,
#        character_name: player.character_name
#      })
#    end)

    broadcast!(socket, "DESPAWN", coords |> Map.put("player_id", socket.assigns.player_id))

    {:noreply, socket}
  end

  def handle_in("REFRESH", character, socket) do
    player = World.Player |> World.Repo.get(socket.assigns.player_id)

    changeset = World.Player.changeset(player, character)
    {:ok, _person} = World.Repo.update(changeset)

    broadcast!(socket, "REFRESH", character |> Map.put("player_id", socket.assigns.player_id))
    {:noreply, socket}
  end

  def handle_in("MOVE", movement, socket) do
    player = World.Player |> World.Repo.get(socket.assigns.player_id)

    changeset = World.Player.changeset(player, %{
      x: movement["x"],
      y: movement["y"],
      direction: movement["direction"],
      move_speed: movement["move_speed"],
      move_frequency: movement["move_frequency"],
    })
    {:ok, _person} = World.Repo.update(changeset)

    broadcast!(socket, "MOVE", movement |> Map.put("player_id", socket.assigns.player_id))
    {:noreply, socket}
  end

  intercept ["SPAWN", "DESPAWN", "REFRESH", "MOVE"]
  def handle_out(action, msg, socket) do
    if msg["player_id"] !== socket.assigns[:player_id] do
      push socket, action, msg
    end
    {:noreply, socket}
  end
end
