# This is free and unencumbered software released into the public domain.

defmodule Lua.Table do
  @moduledoc """
  **This interface is experimental and subject to change.**
  """

  defstruct tref: nil, state: nil

  @type t :: %Lua.Table{}

  @spec new(Lua.State.t) :: Lua.Table.t
  def new(%Lua.State{luerl: state}) do
    {tref, state} = :luerl_emul.alloc_table(state)
    %Lua.Table{tref: tref, state: state}
  end

  @spec wrap({:tref, integer}, Lua.State.t) :: Lua.Table.t
  def wrap({:tref, _} = tref, %Lua.State{luerl: state}) do
    %Lua.Table{tref: tref, state: state}
  end
end
