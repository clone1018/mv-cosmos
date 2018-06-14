defmodule World.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "player" do
    field :name, :string
    field :map_id, :integer
    field :x, :integer
    field :y, :integer
    field :character_index, :integer
    field :character_name, :string
    field :direction, :integer
    field :move_speed, :integer
    field :move_frequency, :integer
  end

  def changeset(player, params \\ %{}) do
    player
      |> cast(params, [:name, :map_id, :x, :y, :character_index, :character_name, :direction, :move_speed, :move_frequency])
#      |> unique_constraint(:name)
    # |a> validate_required([:name, :email])
    # |> validate_inclusion(:age, 18..100)

  end

  def on_map(query, map_id) do
    from c in query,
    where: c.map_id == ^map_id
  end

end
