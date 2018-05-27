defmodule Game.Repo.Migrations.CreateInitialMvDatabase do
  use Ecto.Migration

  def change do
    create table(:class) do
      add :name, :string
      add :note, :string
    end

    create table(:actor) do
      add :name, :string
      add :nickname, :string
      add :profile, :string
      add :note, :string
      add :class_id, references(:class)
      add :battler_name, :string
      add :character_index, :integer
      add :character_name, :string
      add :face_index, :integer
      add :face_name, :string
    end

    create table(:map) do
      add :name, :string
      add :display_name, :string
      add :disable_dashing, :boolean
      add :tileset_id, :integer
    end

    # create table(:event) do
    #   add :name, :string
    #   add :note, :string
    #   add :x, :integer
    #   add :y, :integer
    # end

    # create table(:event_page) do
    #   add :direction_fix, :boolean
    #   add :move_frequency, :integer
    #   add :move_route, :integer
    # end

    # create table(:event_page_list) do
    #   add :direction_fix, :boolean
    #   add :move_frequency, :integer
    #   add :move_route, :integer
    # end

    # create table(:event_page_image) do
    #   add :image_tile_id, :integer
    #   add :image_character_name, :string
    #   add :image_direction, :integer
    #   add :image_pattern, :integer
    #   add :image_character_index, :integer
    # end

    # create table(:event_page_condition) do
    #   # event page id
    #   # actor id
    #   add :actor_valid, :boolean
    #   # item_id
    #   add :item_valid, :boolean
    #   add :self_switch_ch, :string
    #   add :self_switch_valid, :integer
    #   add
    # end
  end
end
