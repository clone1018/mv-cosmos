defmodule Mix.Tasks.Import do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Imports a RPG Maker MV project into the game database"
  def run(path) do
    repos = parse_repo([])
    Enum.each repos, fn repo ->
      ensure_repo(repo, [])
      ensure_started(repo, [])
    end

    map_info = File.read!("#{path}/data/MapInfos.json") |> Poison.decode!()
    Enum.each(tl(map_info), fn(x) ->
      map = %Game.Map{
        id: x["id"],
        name: x["name"]
      }
      Game.Repo.insert(map)
    end)

  end
end
