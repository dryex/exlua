# This is free and unencumbered software released into the public domain.

defmodule LuaStateTest do
  use ExUnit.Case, async: true

  doctest Lua.State

  test "Lua.State.new/0" do
    assert %Lua.State{} = Lua.State.new()
  end

  test "Lua.State.wrap/1" do
    assert %Lua.State{} = Lua.State.wrap(:luerl.init())
  end

  test "Lua.State.unwrap/1" do
    assert [:luerl | _] = Lua.State.unwrap(Lua.State.new()) |> Tuple.to_list
  end
end
