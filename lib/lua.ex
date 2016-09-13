# This is free and unencumbered software released into the public domain.

defmodule Lua do
  alias Lua.{Chunk, Error, State}

  @doc "Encodes an Elixir term as a Lua value."
  @spec encode(nil | boolean | number | binary | atom) :: nil | boolean | float | binary
  def encode(term)
  def encode(nil),   do: nil
  def encode(false), do: false
  def encode(true),  do: true
  def encode(value) when is_integer(value),  do: :erlang.float(value)
  def encode(value) when is_float(value),    do: value
  def encode(value) when is_binary(value),   do: value
  def encode(value) when is_atom(value),     do: Atom.to_string(value)
  def encode(value) when is_function(value), do: {:function, wrap_function(value)}

  @doc "Encodes an Elixir map as a Lua table."
  @spec encode(Lua.State.t, map) :: {Lua.State.t, {:tref, integer}}
  def encode(%State{luerl: state}, value) when is_map(value) do
    {tref, state} = :luerl_emul.alloc_table(state)
    state = Enum.reduce(value, state, fn({k, v}, state) ->
      k = case k do
        k when is_atom(k) -> Atom.to_string(k)
        k when is_binary(k) -> k
      end
      {state, v} = encode(state, v)
      :luerl_emul.set_table_key(tref, k, v, state)
    end)
    {State.wrap(state), tref}
  end

  @doc "Encodes an Elixir term as a Lua value."
  @spec encode(Lua.State.t, nil | boolean | number | binary | atom) ::
    {Lua.State.t, nil | boolean | float | binary}
  def encode(%State{} = state, value), do: {state, encode(value)}

  @doc "Decodes a Lua value as an Elixir term."
  @spec decode(nil | boolean | number | binary) :: term
  def decode(value)
  def decode(nil),   do: nil
  def decode(false), do: false
  def decode(true),  do: true
  def decode(value) when is_number(value), do: value
  def decode(value) when is_binary(value), do: value
  def decode(value), do: value # FIXME

  @doc "Performs garbage collection."
  @spec gc(Lua.State.t) :: Lua.State.t
  def gc(%State{luerl: state}) do
    State.wrap(:luerl.gc(state))
  end

  @doc "Interprets a Lua code snippet, discarding any side effects."
  @spec eval(Lua.State.t, binary) :: {:ok, any} | {:error, any}
  def eval(%State{luerl: state}, code) when is_binary(code) do
    :luerl.eval(code, state)
  end

  @doc "Interprets a Lua code snippet, discarding any side effects."
  @spec eval!(Lua.State.t, binary) :: any
  def eval!(%State{luerl: state}, code) when is_binary(code) do
    case :luerl.eval(code, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Interprets a Lua source file, discarding any side effects."
  @spec eval_file(Lua.State.t, binary) :: {:ok, any} | {:error, any}
  def eval_file(%State{luerl: state}, filepath) when is_binary(filepath) do
    :luerl.evalfile(filepath |> String.to_charlist, state)
  end

  @doc "Interprets a Lua source file, discarding any side effects."
  @spec eval_file!(Lua.State.t, binary) :: any
  def eval_file!(%State{luerl: state}, filepath) when is_binary(filepath) do
    case :luerl.evalfile(filepath |> String.to_charlist, state) do
      {:ok, result}    -> result
      {:error, reason} -> raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Interprets a Lua code snippet, for its side effects."
  @spec exec!(Lua.State.t, binary) :: Lua.State.t
  def exec!(%State{luerl: state}, code) when is_binary(code) do
    {_, state} = :luerl.do(code, state)
    State.wrap(state)
  end

  @doc "Interprets a Lua source file, for its side effects."
  @spec exec_file!(Lua.State.t, binary) :: Lua.State.t
  def exec_file!(%State{luerl: state}, filepath) when is_binary(filepath) do
    {_, state} = :luerl.dofile(filepath |> String.to_charlist, state)
    State.wrap(state)
  end

  @doc "Compiles a Lua code snippet into a chunk."
  @spec load(Lua.State.t, binary) :: {:ok, Lua.State.t, Lua.Chunk.t} | {:error, any, any}
  def load(%State{luerl: state}, code) do
    case :luerl.load(code, state) do
      {:ok, function, state} ->
        {:ok, State.wrap(state), %Chunk{luerl: function}}
      error -> error
    end
  end

  @doc "Compiles a Lua code snippet into a chunk."
  @spec load!(Lua.State.t, binary) :: {Lua.State.t, Lua.Chunk.t}
  def load!(%State{luerl: state}, code) do
    case :luerl.load(code, state) do
      {:ok, function, state} ->
        {State.wrap(state), %Chunk{luerl: function}}
      {:error, reason, _} ->
        raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Compiles a Lua source file into a chunk."
  @spec load_file(Lua.State.t, binary) :: {:ok, Lua.State.t, Lua.Chunk.t} | {:error, any, any}
  def load_file(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {:ok, State.wrap(state), %Chunk{luerl: function}}
      error -> error
    end
  end

  @doc "Compiles a Lua source file into a chunk."
  @spec load_file!(Lua.State.t, binary) :: {Lua.State.t, Lua.Chunk.t}
  def load_file!(%State{luerl: state}, filepath) do
    case :luerl.loadfile(filepath |> String.to_charlist, state) do
      {:ok, function, state} ->
        {State.wrap(state), %Chunk{luerl: function}}
      {:error, reason, _} ->
        raise Error, reason: reason, message: inspect(reason)
    end
  end

  @doc "Calls a Lua compiled chunk."
  @spec call_chunk!(Lua.State.t, Lua.Chunk.t, [any]) :: {Lua.State.t, [any]}
  def call_chunk!(%State{luerl: state}, %Chunk{luerl: chunk}, args \\ []) when is_list(args) do
    case :luerl.call_chunk(chunk, args, state) do
      {result, state} -> {State.wrap(state), result}
    end
  end

  def call_function!(state, name, args \\ [])

  @doc "Calls a Lua function."
  @spec call_function!(Lua.State.t, atom, [any]) :: {Lua.State.t, [any]}
  def call_function!(%State{} = state, name, args) when is_atom(name) and is_list(args) do
    call_function!(state, [name], args)
  end

  @doc "Calls a Lua function."
  @spec call_function!(Lua.State.t, [atom], [any]) :: {Lua.State.t, [any]}
  def call_function!(%State{luerl: state}, name, args) when is_list(name) and is_list(args) do
    case :luerl.call_function(name, args, state) do
      {result, state} -> {State.wrap(state), result}
    end
  end

  @doc "Returns the value of a global variable."
  @spec get_global(Lua.State.t, atom) :: {Lua.State.t, any}
  def get_global(%State{} = state, name) when is_atom(name) do
    get_global(state, name |> Atom.to_string)
  end

  @doc "Returns the value of a global variable."
  @spec get_global(Lua.State.t, binary) :: {Lua.State.t, any}
  def get_global(%State{luerl: state}, name) when is_binary(name) do
    {result, state} = :luerl_emul.get_global_key(name, state)
    {State.wrap(state), result}
  end

  @doc "Sets the value of a global variable."
  @spec set_global(Lua.State.t, atom, any) :: Lua.State.t
  def set_global(%State{} = state, name, value) when is_atom(name) do
    set_global(state, name |> Atom.to_string, value)
  end

  @doc "Sets the value of a global variable."
  @spec set_global(Lua.State.t, binary, map) :: Lua.State.t
  def set_global(%State{} = state, name, value) when is_binary(name) and is_map(value) do
    {%State{luerl: state}, tref} = encode(state, value)
    State.wrap(:luerl_emul.set_global_key(name, tref, state))
  end

  @doc "Sets the value of a global variable."
  @spec set_global(Lua.State.t, binary, any) :: Lua.State.t
  def set_global(%State{luerl: state}, name, value) when is_binary(name) do
    State.wrap(:luerl_emul.set_global_key(name, encode(value), state))
  end

  @doc "Returns the value of a table index."
  @spec get_table(Lua.State.t, [atom]) :: {Lua.State.t, any}
  def get_table(%State{luerl: state}, name) when is_list(name) do
    {result, state} = :luerl.get_table(name, state)
    {State.wrap(state), result}
  end

  @doc "Sets a table index to the given value."
  @spec set_table(Lua.State.t, [atom], map) :: Lua.State.t
  def set_table(%State{} = state, name, value) when is_list(name) and is_map(value) do
    name = Enum.map(name, &Atom.to_string/1)
    {%State{luerl: state}, tref} = encode(state, value)
    State.wrap(:luerl_emul.set_table_keys(name, tref, state))
  end

  @doc "Sets a table index to the given value."
  @spec set_table(Lua.State.t, [atom], any) :: Lua.State.t
  def set_table(%State{luerl: state}, name, value) when is_list(name) do
    name = Enum.map(name, &Atom.to_string/1)
    State.wrap(:luerl_emul.set_table_keys(name, encode(value), state))
  end

  @doc "Sets the value of the package.path global variable."
  @spec set_package_path(Lua.State.t, binary) :: Lua.State.t
  def set_package_path(%State{} = state, path) when is_binary(path) do
    set_table(state, [:package, :path], path)
  end

  @doc "Attempts to load a package of the given name."
  @spec require!(Lua.State.t, binary) :: {Lua.State.t, [any]}
  def require!(%State{} = state, package_name) when is_binary(package_name) do
    call_function!(state, :require, [package_name])
  end

  @spec wrap_function(([term] -> nil | [term])) :: fun
  defp wrap_function(function) when is_function(function, 1) do
    fn inputs, state ->
      inputs = inputs |> Enum.map(&decode/1)
      case function.(inputs) do
        nil -> {[], state}
        outputs when is_list(outputs) ->
          {outputs |> Enum.map(&encode/1), state}
      end
    end
  end

  @spec wrap_function((Lua.State.t, [term] -> nil | [term] | {Lua.State.t, [term]})) :: fun
  defp wrap_function(function) when is_function(function, 2) do
    # ExLua's callback calling convention is effectively the reverse of Luerl's.
    fn inputs, state ->
      inputs = inputs |> Enum.map(&decode/1)
      case function.(State.wrap(state), inputs) do
        {%State{luerl: state}, nil} -> {[], state}
        {%State{luerl: state}, outputs} when is_list(outputs) ->
          {outputs |> Enum.map(&encode/1), state}
        outputs when is_list(outputs) ->
          {outputs |> Enum.map(&encode/1), state}
      end
    end
  end
end
