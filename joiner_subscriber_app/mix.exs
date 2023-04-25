defmodule JoinerSubscriberApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :joiner_subscriber_app,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod:  {JoinerSubscriberApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:socket, "~> 0.3"},
      {:poison, "~> 3.1"}
    ]
  end
end
