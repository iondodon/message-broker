defmodule SensorsServer.Starter do
  use Supervisor
  require Logger

  def init(options) do
    Logger.info "Received options #{options}"
    Logger.info "Starting application"
    options
  end

  def start_link(_args) do
    {:ok, _} = Plug.Adapters.Cowboy.http SensorsServer.Sse, [], port: 4000
  end

end
