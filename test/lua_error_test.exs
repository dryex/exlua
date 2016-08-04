# This is free and unencumbered software released into the public domain.

defmodule LuaErrorTest do
  use ExUnit.Case, async: true

  doctest Lua.Error

  test "raise Lua.Error" do
    assert_raise Lua.Error, fn ->
      raise Lua.Error
    end
  end
end
