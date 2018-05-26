defmodule World.MapTest do
  use ExUnit.Case
  doctest World.Map

  test "map is created" do
    assert World.Map.whereis(1) == nil

    {:ok, pid} = World.Map.start_link(1)
    assert World.Map.whereis(1) == pid
  end

end
