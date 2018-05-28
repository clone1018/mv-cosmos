defmodule World.MixProject do
  use Mix.Project

  def project do
    [
      app: :world,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {World, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:game, in_umbrella: true},
      {:plug, "~> 1.2"},
      {:cowboy, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:web_socket, "~> 0.1.0"},
      {:jsex, "~> 2.0"},
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.11"},
    ]
  end
end
