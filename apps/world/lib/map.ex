defmodule World.Map do
  @moduledoc """
  Simple genserver to represent an imaginary account process.
  Requires you provide an integer-based `map_id` upon starting.
  There is a `:fetch_data` callback handler where you could easily get additional account attributes
  from a database or some other source - assuming the `map_id` provided was a valid key to use as
  database criteria.
  """

  use GenServer
  require Logger

  @map_registry_name :map_registry
  @process_lifetime_ms 10 # 24 hours in milliseconds - make this number shorter to experiement with process termination

  # Just a simple struct to manage the state for this genserver
  # You could add additional attributes here to keep track of for a given account
  defstruct map_id: 0,
            name: "",
            timer_ref: nil


  @doc """
  Starts a new account process for a given `map_id`.
  """
  def start_link(map_id) when is_integer(map_id) do
    GenServer.start_link(__MODULE__, [map_id], name: via_tuple(map_id))
  end


  # registry lookup handler
  defp via_tuple(map_id), do: {:via, Registry, {@map_registry_name, map_id}}


  @doc """
  Return some details (state) for this account process
  """
  def details(map_id) do
    GenServer.call(via_tuple(map_id), :get_details)
  end


  @doc """
  Returns the pid for the `map_id` stored in the registry
  """
  def whereis(map_id) do
    case Registry.lookup(@map_registry_name, map_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end


  @doc """
  Init callback
  """
  def init([map_id]) do

    # Add a msg to the process mailbox to
    # tell this process to run `:fetch_data`
    send(self(), :fetch_data)
    send(self(), :set_terminate_timer)

    Logger.info("Process created... Map ID: #{map_id}")

    # Set initial state and return from `init`
    {:ok, %__MODULE__{ map_id: map_id }}
  end


  @doc """
  Our imaginary callback handler to get some data from a DB to
  update the state on this process.
  """
  def handle_info(:fetch_data, state) do

    # update the state from the DB in imaginary land. Hardcoded for now.
    updated_state =
      %__MODULE__{ state | name: "Map #{state.map_id}" }

    {:noreply, updated_state}
  end

  @doc """
  Callback handler that sets a timer for 24 hours to terminate this process.
  You can call this more than once it will continue to `push out` the timer (and cleans up the previous one)
  I could have combined the logic below and used just one callback handler, but I like seperating the
  concern of creating an initial timer reference versus destroying an existing one. But that is up to you.
  """
  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: nil } = state) do
    # This is the first time we've dealt with this account, so lets set our timer reference attribute
    # to end this process in 24 hours from now

    # set a timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end
  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: timer_ref } = state) do
    # This match indicates we are in a situation where `state.timer_ref` is not nil -
    # so we already have dealt with this account before

    # let's cancel the existing timer
    timer_ref |> Process.cancel_timer

    # set a new timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end


  @doc """
  Gracefully end this process
  """
  def handle_info(:end_process, state) do
    Logger.info("Process terminating... Map ID: #{state.map_id}")
    {:stop, :normal, state}
  end


  @doc false
  def handle_call(:get_details, _from, state) do
    {:reply, state, state}
  end

end
