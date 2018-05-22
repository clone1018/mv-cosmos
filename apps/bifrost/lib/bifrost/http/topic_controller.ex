defmodule Bifrost.Http.TopicController do
  def handle(:init, state) do
    {:ok, state}
  end
  def handle(:terminate, _state) do
    :ok
  end
  def handle("topic:" <> letter, state, data) do
    IO.inspect({letter, state, data})
    payload = %{awesome: "blah #{letter}",
                orig: data}
    {:reply, {:text, payload}, state}
  end
end
