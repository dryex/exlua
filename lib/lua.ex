# This is free and unencumbered software released into the public domain.

defmodule Lua do
  alias Lua.{Chunk, Error, State}

  @doc "Encodes an Elixir term as a Lua value."
  @spec encode(nil | boolean | number | binary | atom) :: nil | boolean | float | binary
  def encode(term)
  def encode(nil),   do: nil
  def encode(false), do: false
  def encode(true),  do: true
  def encode(value) when is_integer(value), do: :erlang.float(value)
  def encode(value) when is_float(value),   do: value
  def encode(value) when is_binary(value),  do: value
  def encode(value) when is_atom(value),    do: Atom.to_string(value)

  @doc "Decodes a Lua value as an Elixir term."
  @spec decode(nil | boolean | number | binary) :: term
  def decode(value)
  def decode(nil),   do: nil
  def decode(false), do: false
  def decode(true),  do: true
  def decode(value) when is_number(value), do: value
  def decode(value) when is_binary(value), do: value

  @doc "Performs garbage collection."
  @spec gc(Lua.State.t) :: Lua.State.t
  def gc(%State{luerl: state}) do
    %State{luerl: :luerl.gc(state)}
  end

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

  @doc "Compiles a Lua code snippet into a chunk."
  @spec load(Lua.State.t, binary) :: {:ok, Lua.State.t, Lua.Chunk.t} | {:error, any, any}
  def load(%State{luerl: state}, code) do
    case :luerl.load(code, state) do
      {:ok, function, state} ->
        {:ok, %State{luerl: state}, %Chunk{luerl: function}}
      error -> error
    end
  end

  @doc "Compiles a Lua code snippet into a chunk."
  @spec load!(Lua.State.t, binary) :: {Lua.State.t, Lua.Chunk.t}
  def load!(%State{luerl: state}, code) do
    case :luerl.load(code, state) do
      {:ok, function, state} ->
        {%State{luerl: state}, %Chunk{luerl: function}}
      {:error, reason, _} ->
        raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Compiles a Lua source file into a chunk."
  @spec load_file(Lua.State.t, binary) :: {:ok, Lua.State.t, Lua.Chunk.t} | {:error, any, any}
  def load_file(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {:ok, %State{luerl: state}, %Chunk{luerl: function}}
      error -> error
    end
  end

  @doc "Compiles a Lua source file into a chunk."
  @spec load_file!(Lua.State.t, binary) :: {Lua.State.t, Lua.Chunk.t}
  def load_file!(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {%State{luerl: state}, %Chunk{luerl: function}}
      {:error, reason, _} ->
        raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Calls a Lua compiled chunk."
  @spec call_chunk!(Lua.State.t, Lua.Chunk.t, [any]) :: {Lua.State.t, [any]}
  def call_chunk!(%State{luerl: state}, %Chunk{luerl: chunk}, args \\ []) when is_list(args) do
    case :luerl.call_chunk(chunk, args, state) do
      {result, state} -> {%State{luerl: state}, result}
    end
  end

  def call_function!(state, name, args \\ [])

  @doc "Calls a Lua function."
  @spec call_function!(Lua.State.t, atom, [any]) :: {Lua.State.t, [any]}
  def call_function!(%State{luerl: _} = state, name, args) when is_atom(name) and is_list(args) do
    call_function!(state, [name], args)
  end

  @doc "Calls a Lua function."
  @spec call_function!(Lua.State.t, [atom], [any]) :: {Lua.State.t, [any]}
  def call_function!(%State{luerl: state}, name, args) when is_list(name) and is_list(args) do
    case :luerl.call_function(name, args, state) do
      {result, state} -> {%State{luerl: state}, result}
    end
  end

  @doc "Returns the value of a global variable."
  @spec get_global(Lua.State.t, atom) :: {Lua.State.t, any}
  def get_global(%State{luerl: _} = state, name) when is_atom(name) do
    get_global(state, name |> Atom.to_string)
  end

  @doc "Returns the value of a global variable."
  @spec get_global(Lua.State.t, binary) :: {Lua.State.t, any}
  def get_global(%State{luerl: state}, name) when is_binary(name) do
    {result, state} = :luerl_emul.get_global_key(name, state)
    {%State{luerl: state}, result}
  end

  @doc "Sets the value of a global variable."
  @spec set_global(Lua.State.t, atom, any) :: Lua.State.t
  def set_global(%State{luerl: _} = state, name, value) when is_atom(name) do
    set_global(state, name |> Atom.to_string, value)
  end

  @doc "Sets the value of a global variable."
  @spec set_global(Lua.State.t, binary, any) :: Lua.State.t
  def set_global(%State{luerl: state}, name, value) when is_binary(name) do
    value = case value do
      f when is_function(f) -> {:function, wrap_callback(f)}
      v -> v
    end
    %State{luerl: :luerl_emul.set_global_key(name, value, state)}
  end

  @doc "Returns the value of a table index."
  @spec get_table(Lua.State.t, [atom]) :: {Lua.State.t, any}
  def get_table(%State{luerl: state}, name) when is_list(name) do
    {result, state} = :luerl.get_table(name, state)
    {%State{luerl: state}, result}
  end

  @doc "Sets a table index to the given value."
  @spec set_table(Lua.State.t, [atom], any) :: Lua.State.t
  def set_table(%State{luerl: state}, name, value) when is_list(name) do
    value = case value do
      f when is_function(f) -> wrap_callback(f)
      v -> v
    end
    %State{luerl: :luerl.set_table(name, value, state)}
  end

  @doc "Sets the value of the package.path global variable."
  @spec set_package_path(Lua.State.t, binary) :: Lua.State.t
  def set_package_path(%State{luerl: _} = state, path) when is_binary(path) do
    set_table(state, [:package, :path], path)
  end

  @doc "Attempts to load a package of the given name."
  @spec require!(Lua.State.t, binary) :: {Lua.State.t, [any]}
  def require!(%State{luerl: _} = state, package_name) when is_binary(package_name) do
    call_function!(state, :require, [package_name])
  end

  @spec wrap_callback(fun) :: fun
  defp wrap_callback(function) do
    fn args, state ->
      {%State{luerl: state}, result} = function.(State.wrap(state), args)
      {result, state}
    end
  end
end
