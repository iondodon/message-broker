defmodule MessageBrokerApp do
  use Application

  # the app (message broker) starts from here
  def start(_type, _args) do
    # start a new process
    BrokerSupervisor.start_link()
  end

end
