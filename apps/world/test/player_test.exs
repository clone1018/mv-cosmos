defmodule World.PlayerTest do
  use ExUnit.Case
  doctest World.Player

  test "player is created" do
    assert World.Player.whereis(1) == nil

    {:ok, pid} = World.Player.start_link(1)
    assert World.Player.whereis(1) == pid
  end

  test "player position can be updated" do
    World.Player.start_link(2)

    details = World.Player.details(2)
    assert details.map_id == 0
    assert details.x == 0
    assert details.y == 0

    World.Player.update_position(2, 123, 20, 19)

    details = World.Player.details(2)
    assert details.map_id == 123
    assert details.x == 20
    assert details.y == 19
  end

end
