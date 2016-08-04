# This is free and unencumbered software released into the public domain.

defmodule Lua.State do
  defstruct luerl: nil

  @type t :: struct

  @spec new() :: Lua.State.t
  def new do
    %Lua.State{luerl: :luerl.init()}
  end
end
