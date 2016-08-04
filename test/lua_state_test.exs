# This is free and unencumbered software released into the public domain.

defmodule LuaStateTest do
  use ExUnit.Case, async: true

  doctest Lua.State

  test "Lua.State.new" do
    assert Lua.State.new() != nil
  end
end
