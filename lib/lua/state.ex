# This is free and unencumbered software released into the public domain.

defmodule Lua.State do
  defstruct luerl: nil

  @type t :: struct

  @spec new() :: Lua.State.t
  def new do
    wrap(:luerl.init())
  end

  @spec wrap(tuple) :: Lua.State.t
  def wrap(state) do
    %Lua.State{luerl: state}
  end

  @spec unwrap(Lua.State.t) :: tuple
  def unwrap(%Lua.State{luerl: state}) do
    state
  end
end
