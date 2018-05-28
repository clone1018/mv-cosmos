defmodule World.Player do
  use Ecto.Schema
  import Ecto.Changeset

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
      # |> validate_required([:name, :email])
      # |> validate_inclusion(:age, 18..100)
      # |> unique_constraint(:name)
  end
end
