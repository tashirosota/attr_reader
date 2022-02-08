defmodule AttrReader.MixProject do
  use Mix.Project
  @version "0.1.0"
  @source_url "https://github.com/tashirosota/attr-reader"
  @description "Defines module attributes getter automatically like Ruby's attr_reader"

  def project do
    [
      app: :attr_reader,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: @description,
      name: "AttrReader",
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Sota Tashiro"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp deps do
    [
      {:r_enum, "~> 0.7.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
