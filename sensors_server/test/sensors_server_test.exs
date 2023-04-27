defmodule SensorsServerTest do
  use ExUnit.Case
  doctest SensorsServer

  test "greets the world" do
    assert SensorsServer.hello() == :world
  end
end
