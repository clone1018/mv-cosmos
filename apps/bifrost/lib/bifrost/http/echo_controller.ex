defmodule Bifrost.Http.EchoController do
  def echo(:init, state) do
    state = %{state | use_topics: false}
    {:ok, state}
  end
  def echo(:terminate, _state) do
    :ok
  end
  def echo(message, state)do
    IO.inspect(message)
    {:reply, {:text, message}, state}
  end
end
