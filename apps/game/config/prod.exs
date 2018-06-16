# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :game, Game.Repo,
       adapter: Ecto.Adapters.Postgres,
       username: System.get_env("GAME_DATABASE_USERNAME"),
       password: System.get_env("GAME_DATABASE_PASSWORD"),
       database: System.get_env("GAME_DATABASE_NAME"),
       hostname: System.get_env("GAME_DATABASE_HOST"),
       pool_size: 20