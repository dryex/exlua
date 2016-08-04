# This is free and unencumbered software released into the public domain.

defmodule Lua do
  alias Lua.{Error, State}

  @doc "Evaluates a string of Lua code."
  def eval(%State{luerl: state}, code) do
    :luerl.eval(code, state)
  end

  @doc "Evaluates a string of Lua code."
  def eval!(%State{luerl: state}, code) do
    case :luerl.eval(code, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: "Lua.eval!/2 failed"
    end
  end
end
