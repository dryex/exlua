# This is free and unencumbered software released into the public domain.

defmodule Lua.Table do
  @moduledoc """
  **This interface is experimental and subject to change.**
  """

  defstruct tref: nil, version: 0, state: nil

  @type t :: %Lua.Table{}

  @type key :: atom | binary

  @type value :: any

  @spec new(Lua.State.t) :: Lua.Table.t
  def new(%Lua.State{luerl: state}) do
    {tref, state} = :luerl_emul.alloc_table(state)
    %Lua.Table{tref: tref, state: state}
  end

  @spec wrap({:tref, integer}, Lua.State.t) :: Lua.Table.t
  def wrap({:tref, _} = tref, %Lua.State{luerl: state}) do
    %Lua.Table{tref: tref, state: state}
  end

  @spec put(Lua.Table.t, Lua.Table.key, Lua.Table.value) :: Lua.Table.t
  def put(%Lua.Table{tref: tref, version: version, state: state} = table, key, val) do
    k = encode_key(key)
    {state, v} = Lua._encode(state, val)
    state = :luerl_emul.set_table_key(tref, k, v, state)
    %{table | state: state, version: version + 1}
  end

  @spec encode_key(key) :: binary
  defp encode_key(key) do
    case key do
      k when is_atom(k)   -> Atom.to_string(k)
      k when is_binary(k) -> k
    end
  end

  @spec to_map(Lua.Table.t) :: map
  def to_map(%Lua.Table{tref: tref, state: state} = _table) do
    Enum.reduce(:luerl.decode(tref, state), %{}, fn {k, v}, map ->
      Map.put(map, k, v)
    end)
  end
end

defimpl Inspect, for: Lua.Table do
  import Inspect.Algebra

  def inspect(%Lua.Table{tref: {:tref, id}, version: version}, opts) do
    concat ["#Lua.Table<", to_doc(id, opts), "@", to_doc(version, opts), ">"]
  end
end
