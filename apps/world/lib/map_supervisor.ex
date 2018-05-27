defmodule World.MapSupervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic `World.Map` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.

  These processes will spawn for each `map_id` provided to the
  `World.Map.start_link` function.

  Functions contained in this supervisor module will assist in the creation and retrieval of
  new map processes.

  Also note the guards utilizing `is_integer(map_id)` on the functions. My feeling here is that
  if someone makes a mistake and tries sending a string-based key or an atom, I'll just _"let it crash"_.
  """

  use Supervisor
  require Logger


  @map_registry_name :map_registry

  @doc """
  Starts the supervisor.
  """
  def start_link do
    res = Supervisor.start_link(__MODULE__, [], name: __MODULE__)

    Enum.each(Game.Map |> Game.Repo.all(), fn(map) ->
      World.MapSupervisor.find_or_create_process(map.id)
    end)

    res
  end


  @doc """
  Will find the process identifier (in our case, the `map_id`) if it exists in the registry and
  is attached to a running `World.Map` process.

  If the `map_id` is not present in the registry, it will create a new `World.Map`
  process and add it to the registry for the given `map_id`.

  Returns a tuple such as `{:ok, map_id}` or `{:error, reason}`
  """
  def find_or_create_process(map_id) when is_integer(map_id) do
    if map_process_exists?(map_id) do
      {:ok, map_id}
    else
      map_id |> create_map_process
    end
  end


  @doc """
  Determines if a `World.Map` process exists, based on the `map_id` provided.

  Returns a boolean.

  ## Example
      iex> World.MapSupervisor.map_process_exists?(6)
      false
  """
  def map_process_exists?(map_id) when is_integer(map_id) do
    case Registry.lookup(@map_registry_name, map_id) do
      [] -> false
      _ -> true
    end
  end


  @doc """
  Creates a new map process, based on the `map_id` integer.

  Returns a tuple such as `{:ok, map_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_map_process(map_id) when is_integer(map_id) do
    case Supervisor.start_child(__MODULE__, [map_id]) do
      {:ok, _pid} -> {:ok, map_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end


  @doc """
  Returns the count of `World.Map` processes managed by this supervisor.

  ## Example
      iex> World.MapSupervisor.map_process_count
      0
  """
  def map_process_count, do: Supervisor.which_children(__MODULE__) |> length


  @doc """
  Return a list of `map_id` integers known by the registry.

  ex - `[1, 23, 46]`
  """
  def map_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, map_proc_pid, _, _} ->
      Registry.keys(@map_registry_name, map_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end


  @doc false
  def init(_) do
    children = [
      worker(World.Map, [], restart: :temporary)
    ]

    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end

end
