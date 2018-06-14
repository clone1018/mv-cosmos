defmodule World.Http.BroadcastTest do
  use ExUnit.Case, async: false
  doctest World.Http.Broadcast

  test "broadcasts to clients" do
    # {:ok, _pid} = World.PlayerSupervisor.find_or_create_process(1)
    # {:ok, _pid} = World.PlayerSupervisor.find_or_create_process(2)

    # assert World.Http.Broadcast.to_all("") == [1,2]
  end

end
