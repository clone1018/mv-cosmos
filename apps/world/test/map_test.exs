defmodule World.MapTest do
  use ExUnit.Case
  doctest World.Map

  test "map is created" do
    assert World.Map.whereis(1) == nil

    {:ok, id} = World.MapSupervisor.find_or_create_process(1)
    assert id == 1
  end

end
