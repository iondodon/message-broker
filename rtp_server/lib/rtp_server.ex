defmodule RtpServer.Starter do
  @moduledoc """
  Documentation for RtpServer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> RtpServer.hello()
      :world

  """

  use Supervisor
  require Logger


  def init(options) do
    Logger.info "Received options #{options}"
    Logger.info "Starting application"
    options
  end

  def start_link(_args) do
    {:ok, _} = Plug.Adapters.Cowboy.http RtpServer.Sse, [], port: 4000
  end
end
