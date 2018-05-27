defmodule Game.Class do
  use Ecto.Schema

  schema "class" do
    field :name, :string
    field :note, :string
    has_many :actor, Game.Actor
  end
end
