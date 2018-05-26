defmodule World.Http.WebsocketRouterTest do
  use ExUnit.Case
  doctest World.Http.WebsocketRouter

  test "routes simple connect" do
    inp = "[0,123,456]"

    World.Http.WebsocketRouter.handle(inp, %{})
  end

  test "doesnt route out of bounds action" do
    inp = "[1234567890,1,2,3,4]"

    assert_raise(KeyError, fn ->
      World.Http.WebsocketRouter.handle(inp, %{})
    end)
  end

end
