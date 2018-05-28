defmodule World.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:player) do
      add :name, :string
      add :map_id, :integer
      add :x, :integer
      add :y, :integer
      add :character_index, :integer
      add :character_name, :string
      add :direction, :integer
      add :move_speed, :integer
      add :move_frequency, :integer
    end
  end
end
