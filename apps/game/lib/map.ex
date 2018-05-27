defmodule Game.Map do
  use Ecto.Schema

  schema "map" do
    field :name, :string
    field :display_name, :string
    field :disable_dashing, :boolean
    field :tileset_id, :integer
  end
end
