defmodule Bifrost.WebsocketHandler do
  @connection Plug.Adapters.Cowboy2.Conn
  @already_sent {:plug_conn, :sent}

  def init(req, state) do
    IO.inspect(req)

    conn = @connection.conn(req)

    {:ok, req, []}
  end

  def websocket_init(_param) do
    IO.puts("websocket_init")
  end

  def websocket_handle(_param, _paramtwo) do
    IO.puts("websocket_handle")
  end

  def websocket_info(_one, _two) do
    IO.puts("websocket_info")
  end

  defp maybe_send(%Plug.Conn{state: :unset}, _plug), do: raise(Plug.Conn.NotSentError)
  defp maybe_send(%Plug.Conn{state: :set} = conn, _plug), do: Plug.Conn.send_resp(conn)
  defp maybe_send(%Plug.Conn{} = conn, _plug), do: conn

  defp maybe_send(other, plug) do
    raise "Cowboy2 adapter expected #{inspect(plug)} to return Plug.Conn but got: " <>
            inspect(other)
  end
end

# defmodule Bifrost.WebsocketHandler do
#   @behaviour :cowboy_websocket_handler

#   def init(_, _req, _opts) do
#     IO.inspect("init")
#     {:upgrade, :protocol, :cowboy_websocket}
#   end

#   @timeout 60000 # terminate if no activity for one minute

#   #Called on websocket connection initialization.
#   def websocket_init(_type, req, _opts) do
#     state = %{}
#     {:ok, req, state, @timeout}
#   end

#   # Handle 'ping' messages from the browser - reply
#   def websocket_handle({:text, "ping"}, req, state) do
#     {:reply, {:text, "pong"}, req, state}
#   end

#   # Handle other messages from the browser - don't reply
#   def websocket_handle({:text, message}, req, state) do
#     IO.puts(message)
#     {:ok, req, state}
#   end

#   # Format and forward elixir messages to client
#   def websocket_info(message, req, state) do
#     {:reply, {:text, message}, req, state}
#   end

#   # No matter why we terminate, remove all of this pids subscriptions
#   def websocket_terminate(_reason, _req, _state) do
#     :ok
#   end
# end
