defmodule KinoUtil.MixProject do
  use Mix.Project

  @name "kino_util"
  @description "Livebook smart cell to show system utilization."
  @version "0.1.0"

  def project do
    [
      app: :kino_util,
      name: @name,
      description: @description,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :os_mon],
      mod: {KinoUtil.Application, []}
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.9.4"}
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mvkvc/kino_util"}
    ]
  end
end
