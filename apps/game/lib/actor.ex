defmodule Game.Actor do
  use Ecto.Schema

  schema "actor" do
    field :name, :string
    field :nickname, :string
    field :profile, :string
    field :note, :string
    field :battler_name, :string
    field :character_index, :integer
    field :character_name, :string
    field :face_index, :integer
    field :face_name, :string
    belongs_to :class, Game.Class
  end
end
