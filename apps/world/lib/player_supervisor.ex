defmodule World.PlayerSupervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic `World.Player` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.

  These processes will spawn for each `player_id` provided to the
  `World.Player.start_link` function.

  Functions contained in this supervisor module will assist in the creation and retrieval of
  new player processes.

  Also note the guards utilizing `is_integer(player_id)` on the functions. My feeling here is that
  if someone makes a mistake and tries sending a string-based key or an atom, I'll just _"let it crash"_.
  """

  use Supervisor
  require Logger


  @player_registry_name :player_registry

  @doc """
  Starts the supervisor.
  """
  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)


  @doc """
  Will find the process identifier (in our case, the `player_id`) if it exists in the registry and
  is attached to a running `World.Player` process.

  If the `player_id` is not present in the registry, it will create a new `World.Player`
  process and add it to the registry for the given `player_id`.

  Returns a tuple such as `{:ok, player_id}` or `{:error, reason}`
  """
  def find_or_create_process(player_id) when is_integer(player_id) do
    if player_process_exists?(player_id) do
      {:ok, player_id}
    else
      player_id |> create_player_process
    end
  end


  @doc """
  Determines if a `World.Player` process exists, based on the `player_id` provided.

  Returns a boolean.

  ## Example
      iex> World.PlayerSupervisor.player_process_exists?(6)
      false
  """
  def player_process_exists?(player_id) when is_integer(player_id) do
    case Registry.lookup(@player_registry_name, player_id) do
      [] -> false
      _ -> true
    end
  end


  @doc """
  Creates a new player process, based on the `player_id` integer.

  Returns a tuple such as `{:ok, player_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_player_process(player_id) when is_integer(player_id) do
    case Supervisor.start_child(__MODULE__, [player_id]) do
      {:ok, _pid} -> {:ok, player_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end


  @doc """
  Returns the count of `World.Player` processes managed by this supervisor.

  ## Example
      iex> World.PlayerSupervisor.player_process_count
      0
  """
  def player_process_count, do: Supervisor.which_children(__MODULE__) |> length


  @doc """
  Return a list of `player_id` integers known by the registry.

  ex - `[1, 23, 46]`
  """
  def player_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, player_proc_pid, _, _} ->
      Registry.keys(@player_registry_name, player_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end


  @doc """
  Return a list of widgets ordered per player.

  The list will be made up of a map structure for each child player process.

  ex - `[%{player_id: 2, widgets_sold: 1}, %{player_id: 10, widgets_sold: 1}]`
  """
  def get_all_player_widgets_ordered do
    player_ids() |> Enum.map(&(%{ player_id: &1, widgets_sold: World.Player.widgets_ordered(&1) }))
  end


  @doc false
  def init(_) do
    children = [
      worker(World.Player, [], restart: :temporary)
    ]

    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end

end
