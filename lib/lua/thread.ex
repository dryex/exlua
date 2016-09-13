# This is free and unencumbered software released into the public domain.

defmodule Lua.Thread do
  @moduledoc """
  """

  use GenServer

  defstruct state: %Lua.State{}, result: nil

  @type t :: %Lua.Thread{}

  @spec start_link(binary, Lua.State.t, GenServer.options)
    :: GenServer.on_start | {:error, any, any}
  def start_link(filepath, state \\ nil, options \\ []) when is_binary(filepath) do
    state = state || Lua.State.new

    case Lua.load_file(state, filepath) do
      {:ok, state, chunk} ->
        GenServer.start_link(__MODULE__, [state, chunk], options)

      error -> error
    end
  end

  @spec init([struct]) :: any
  def init([state, chunk]) do
    {state, result} = Lua.call_chunk!(state, chunk)
    {:ok, %Lua.Thread{state: state, result: result}}
  end

  @spec call_function(pid, atom | [atom], [any]) :: any
  def call_function(pid, function_name, function_args \\ []) do
    GenServer.call(pid, {:call_function, function_name, function_args})
  end

  @spec handle_call({:call_function, atom | [atom], [any]}, pid, Lua.Thread.t) :: {:reply, any, Lua.Thread.t}
  def handle_call({:call_function, function_name, function_args}, _from, thread) do
    {state, result} = Lua.call_function!(thread.state, function_name, function_args)
    {:reply, result, %{thread | state: state}}
  end
end
