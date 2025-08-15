defmodule CVR.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/Munksgaard/ex_cvr"

  def project do
    [
      app: :cvr,
      name: "CVR",
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [
          :unmatched_returns,
          :error_handling,
          :extra_return,
          :missing_return,
          :underspecs,
          :no_opaque
        ]
      ],
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Optional functionality
      {:stream_data, "~> 1.2", optional: true},
      # Testing
      {:credo, "~> 1.7.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.3", only: :dev, runtime: false},
      {:ex_doc, "~> 0.37", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    A library for validating and generating Danish CVR-numbers and P-numbers.
    """
  end

  defp package do
    [
      maintainers: ["Philip Munksgaard"],
      licenses: ["Apache-2.0"],
      links: links(),
      files: [
        "lib",
        "mix.exs",
        "LICENSE*"
      ]
    ]
  end

  def links do
    %{
      "GitHub" => "#{@source_url}"
    }
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: @source_url,
      main: "CVR",
      extras: [
        "LICENSE.md"
      ],
      formatters: ["html"]
    ]
  end
end
