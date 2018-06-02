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
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # def handle_in("MOVE", movement, socket) do
  def handle_in("MOVE", movement, socket) do
    IO.inspect(movement)
    # broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end
end
