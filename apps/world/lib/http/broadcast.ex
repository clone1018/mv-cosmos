defmodule World.Http.Broadcast do

  def to_all(message) do
    players = World.PlayerSupervisor.player_ids()
  end

end
