defmodule WebElixirTest do
  use ExUnit.Case
  doctest WebElixir

  test "greets the world" do
    assert WebElixir.hello() == :world
  end
end
