defmodule Bifrost.BasicTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Bifrost.Router.init([])

  test "user gets nice message" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = Bifrost.Router.call(conn, @opts)

    assert conn.resp_body == "Hello from plug"
  end

end
