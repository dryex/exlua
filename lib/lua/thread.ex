# This is free and unencumbered software released into the public domain.

defmodule Lua.Thread do
  @moduledoc """
  **This interface is experimental and subject to change.**
  """

  use GenServer

  defstruct state: %Lua.State{}, result: nil

  @type t :: %Lua.Thread{}

  @spec start_link(binary, Lua.State.t, GenServer.options)
    :: GenServer.on_start | {:error, any, any}
  def start_link(filepath, state \\ nil, options \\ []) when is_binary(filepath) do
    state = state || Lua.State.new()

    case Lua.load_file(state, filepath) do
      {:ok, state, chunk} ->
        GenServer.start_link(__MODULE__, [state, chunk], options)

      error -> error
    end
  end

  @doc "Calls a function in the Lua thread synchronously, awaiting a result."
  @spec call_function(GenServer.server, atom | [atom], [term]) :: [term]
  def call_function(thread, function_name, function_args \\ []) do
    GenServer.call(thread, {:call_function, function_name, function_args})
  end

  @doc "Executes a function in the Lua thread asynchronously, discarding any result."
  @spec exec_function(GenServer.server, atom | [atom], [term]) :: :ok
  def exec_function(thread, function_name, function_args \\ []) do
    GenServer.cast(thread, {:exec_function, function_name, function_args})
  end

  @spec init([struct]) :: {:ok, Lua.Thread.t}
  def init([state, chunk]) do
    {state, result} = Lua.call_chunk!(state, chunk)
    {:ok, %Lua.Thread{state: state, result: result}}
  end

  @spec handle_call({:call_function, atom | [atom], [term]}, pid, Lua.Thread.t)
    :: {:reply, [term], Lua.Thread.t}
  def handle_call({:call_function, function_name, function_args}, _from, thread) do
    {state, result} = Lua.call_function!(thread.state, function_name, function_args)
    {:reply, result, %{thread | state: state}}
  end

  @spec handle_cast({:exec_function, atom | [atom], [term]}, Lua.Thread.t)
    :: {:noreply, Lua.Thread.t}
  def handle_cast({:exec_function, function_name, function_args}, thread) do
    {state, _result} = Lua.call_function!(thread.state, function_name, function_args)
    {:noreply, %{thread | state: state}}
  end
end
