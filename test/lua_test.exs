# This is free and unencumbered software released into the public domain.

defmodule LuaTest do
  use ExUnit.Case, async: true

  doctest Lua

  test "Lua.gc!/1" do
    assert %Lua.State{} = Lua.gc(Lua.State.new)
  end

  test "Lua.eval/2" do
    assert {:ok, [42.0]} = Lua.eval(Lua.State.new, "return 6 * 7")
    assert {:error, _} = Lua.eval(Lua.State.new, "foobar")
  end

  test "Lua.eval!/2" do
    assert [42.0] = Lua.eval!(Lua.State.new, "return 6 * 7")
    assert_raise Lua.Error, fn -> Lua.eval!(Lua.State.new, "foobar") end
  end

  test "Lua.eval_file/2" do
    assert {:ok, [42.0]} = Lua.eval_file(Lua.State.new, "test/scripts/answer.lua")
    assert {:error, _} = Lua.eval_file(Lua.State.new, "test/scripts/_enoent.lua")
  end

  test "Lua.eval_file!/2" do
    assert [42.0] = Lua.eval_file!(Lua.State.new, "test/scripts/answer.lua")
    assert_raise Lua.Error, fn -> Lua.eval_file!(Lua.State.new, "test/scripts/_enoent.lua") end
  end

  test "Lua.load/2" do
    assert {:ok, %Lua.State{}, %Lua.Chunk{}} = Lua.load(Lua.State.new, "return 6 * 7")
    assert {:error, _, _} = Lua.load(Lua.State.new, "foobar")
  end

  test "Lua.load!/2" do
    assert {%Lua.State{}, %Lua.Chunk{}} = Lua.load!(Lua.State.new, "return 6 * 7")
    assert_raise Lua.Error, fn -> Lua.load!(Lua.State.new, "foobar") end
  end

  test "Lua.load_file/2" do
    assert {:ok, %Lua.State{}, %Lua.Chunk{}} = Lua.load_file(Lua.State.new, "test/scripts/hello.lua")
    assert {:error, _, _} = Lua.load_file(Lua.State.new, "test/scripts/_enoent.lua")
  end

  test "Lua.load_file!/2" do
    assert {%Lua.State{}, %Lua.Chunk{}} = Lua.load_file!(Lua.State.new, "test/scripts/hello.lua")
    assert_raise Lua.Error, fn -> Lua.load_file!(Lua.State.new, "test/scripts/_enoent.lua") end
  end

  test "Lua.call_chunk!/3" do
    {state, chunk} = Lua.load!(Lua.State.new, "return 42")
    assert {%Lua.State{}, [42.0]} = Lua.call_chunk!(state, chunk, [])
    {state, chunk} = Lua.load!(Lua.State.new, "return foobar()")
    assert_raise ErlangError, fn -> Lua.call_chunk!(state, chunk, []) end
  end

  test "Lua.call_function!/3" do
    assert {%Lua.State{}, [42.0]} = Lua.call_function!(Lua.State.new, [:math, :abs], [-42])
    assert_raise ErlangError, fn -> Lua.call_function!(Lua.State.new, [:foo, :bar], []) end
  end

  test "Lua.get_global/2" do
    assert {_, 42.0} = Lua.State.new |> Lua.set_table([:val], 42) |> Lua.get_global(:val)
    assert {_, nil} = Lua.State.new |> Lua.get_global(:val)
    assert {_, 42.0} = Lua.State.new |> Lua.set_table([:val], 42) |> Lua.get_global("val")
    assert {_, nil} = Lua.State.new |> Lua.get_global("val")
  end

  test "Lua.get_table/2" do
    assert {_, 42.0} = Lua.State.new |> Lua.set_table([:val], 42) |> Lua.get_table([:val])
    assert {_, nil} = Lua.State.new |> Lua.get_table([:val])
  end

  test "Lua.set_global/3" do
    assert [42] = Lua.State.new |> Lua.set_global(:val, 42) |> Lua.eval!("return val")
    assert [42.0] = Lua.State.new |> Lua.set_global(:inc, fn s, [x] -> {s, [x+1]} end) |> Lua.eval!("return inc(41)")
  end

  test "Lua.set_table/3" do
    assert [42.0] = Lua.State.new |> Lua.set_table([:val], 42) |> Lua.eval!("return val")
    assert [42.0] = Lua.State.new |> Lua.set_table([:inc], fn s, [x] -> {s, [x+1]} end) |> Lua.eval!("return inc(41)")
  end
end
