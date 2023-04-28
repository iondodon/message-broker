defmodule RtpServerTest do
  use ExUnit.Case
  doctest RtpServer

  test "greets the world" do
    assert RtpServer.hello() == :world
  end
end
