# This is free and unencumbered software released into the public domain.

defmodule Lua do
  alias Lua.{Chunk, Error, State}

  @doc "Interprets a Lua code snippet."
  @spec eval(Lua.State.t, binary) :: {:ok, any} | {:error, any}
  def eval(%State{luerl: state}, code) do
    :luerl.eval(code, state)
  end

  @doc "Interprets a Lua code snippet."
  @spec eval!(Lua.State.t, binary) :: any
  def eval!(%State{luerl: state}, code) do
    case :luerl.eval(code, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Interprets a Lua source file."
  @spec eval_file(Lua.State.t, binary) :: {:ok, any} | {:error, any}
  def eval_file(%State{luerl: state}, filepath) do
    :luerl.evalfile(filepath |> String.to_charlist, state)
  end

  @doc "Interprets a Lua source file."
  @spec eval_file!(Lua.State.t, binary) :: any
  def eval_file!(%State{luerl: state}, filepath) do
    case :luerl.evalfile(filepath |> String.to_charlist, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Compiles a Lua source file."
  @spec load_file(Lua.State.t, binary) :: {:ok, Lua.State.t, Lua.Chunk.t} | {:error, any, any}
  def load_file(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {:ok, %State{luerl: state}, %Chunk{luerl: function}}
      error -> error
    end
  end

  @doc "Compiles a Lua source file."
  @spec load_file!(Lua.State.t, binary) :: {Lua.State.t, Lua.Chunk.t}
  def load_file!(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {%State{luerl: state}, %Chunk{luerl: function}}
      {:error, reason, _} ->
        raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Performs garbage collection."
  @spec gc(Lua.State.t) :: Lua.State.t
  def gc(%State{luerl: state}) do
    %State{luerl: :luerl.gc(state)}
  end
end
