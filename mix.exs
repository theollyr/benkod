defmodule Benkod.Mixfile do
  use Mix.Project

  def project do
    [
      app: :benkod,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},

      {:benchee, "~> 0.9", only: :bench},
      {:bento, "~> 0.9", only: :bench},
      {:bencode, "~> 0.3", only: :bench},
      {:bencoder, "~> 0.0.7", only: :bench},
      {:bencodex, github: "patrickgombert/Bencodex", only: :bench},
      {:bencoded, github: "galina/bencoded", only: :bench, app: false},
    ]
  end
end
