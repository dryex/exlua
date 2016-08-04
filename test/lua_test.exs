# This is free and unencumbered software released into the public domain.

defmodule LuaTest do
  use ExUnit.Case, async: true

  doctest Lua

  test "Lua.eval/2" do
    assert Lua.eval(Lua.State.new, "return 6 * 7") == {:ok, [42.0]}
    assert Lua.eval(Lua.State.new, "foobar") == {:error,
      {:badmatch, {:error, [{1, :luerl_parse, 'illegal call'}], []}}}
  end

  test "Lua.eval!/2" do
    assert Lua.eval!(Lua.State.new, "return 6 * 7") == [42.0]
    assert_raise Lua.Error, fn -> Lua.eval!(Lua.State.new, "foobar") end
  end

  test "Lua.eval_file/2" do
    #Lua.eval_file(Lua.State.new, "etc/examples/hello.lua") # FIXME: shebang
  end

  test "Lua.eval_file!/2" do
    #Lua.eval_file!(Lua.State.new, "etc/examples/hello.lua") # FIXME: shebang
  end
end
