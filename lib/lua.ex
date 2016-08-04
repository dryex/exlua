# This is free and unencumbered software released into the public domain.

defmodule Lua do
  alias Lua.{Error, State}

  @doc "Evaluates a Lua code snippet."
  @spec eval(Lua.State.t, binary) :: any
  def eval(%State{luerl: state}, code) do
    :luerl.eval(code, state)
  end

  @doc "Evaluates a Lua code snippet."
  @spec eval!(Lua.State.t, binary) :: any
  def eval!(%State{luerl: state}, code) do
    case :luerl.eval(code, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Evaluates a Lua file."
  @spec eval_file(Lua.State.t, binary) :: any
  def eval_file(%State{luerl: state}, path)  do
    :luerl.evalfile(path |> String.to_charlist, state)
  end

  @doc "Evaluates a Lua file."
  @spec eval_file!(Lua.State.t, binary) :: any
  def eval_file!(%State{luerl: state}, path) do
    case :luerl.evalfile(path |> String.to_charlist, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Performs garbage collection."
  @spec gc(Lua.State.t) :: Lua.State.t
  def gc(%State{luerl: state}) do
    %State{luerl: :luerl.gc(state)}
  end
end
