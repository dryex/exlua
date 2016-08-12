ExLua
=====

[![Project license](https://img.shields.io/badge/license-Public%20Domain-blue.svg)](https://unlicense.org/)
[![Travis CI build status](https://img.shields.io/travis/bendiken/exlua/master.svg)](https://travis-ci.org/bendiken/exlua)
[![Coveralls.io code coverage](https://img.shields.io/coveralls/bendiken/exlua/master.svg)](https://coveralls.io/github/bendiken/exlua)
[![Hex.pm package](https://img.shields.io/hexpm/v/exlua.svg)](https://hex.pm/packages/exlua)
[![Hex.pm downloads](https://img.shields.io/hexpm/dt/exlua.svg)](https://hex.pm/packages/exlua)
[![Gratipay donations](https://img.shields.io/gratipay/user/bendiken.svg)](https://gratipay.com/~bendiken/)

Lua for Elixir, based on [Luerl](https://github.com/rvirding/luerl).

Examples
--------

```elixir
  [42.0] = Lua.State.new |> Lua.eval!("return 6 * 7")

  Lua.State.new
  |> Lua.set_global(:a, 6)
  |> Lua.set_global(:b, 7)
  |> Lua.set_global(:mul, fn st, [a, b] -> {st, [a * b]} end)
  |> Lua.eval!("return {a = a, b = b, c = mul(a, b)}")
  |> Enum.at(0)
  |> Map.new
```

Reference
---------

https://hexdocs.pm/exlua/

### Types

| ExLua (Elixir)          | Luerl (Erlang)          | Lua                     |
| :---------------------- | :---------------------- | :---------------------- |
| `nil`                   | `'nil'`                 | `nil`                   |
| `true`, `false`         | `'true'`, `'false'`     | `true`, `false`         |
| integer                 | integer                 | number                  |
| float                   | float                   | number                  |
| string (binary)         | binary                  | string                  |
| `{:function, ...}`      | `#function{...}`        | function                |
| `{:userdata, ...}`      | `#userdata{...}`        | userdata                |
| `{:thread, ...}`        | `#thread{...}`          | thread                  |
| `{:table, ...}`         | `#table{...}`           | table                   |

### Functions

| ExLua (Elixir)          | Luerl (Erlang)          | Lua (C)                 |
| :---------------------- | :---------------------- | :---------------------- |
| `Lua.Error`             | `{:error, ...}`         | `luaL_error`            |
| `Lua.State.new`         | `luerl:init`            | `luaL_newstate`         |
| `Lua.call_chunk!`       | `luerl:call_chunk`      | `lua_pcall`             |
| `Lua.call_function!`    | `luerl:call_function`   | `lua_pcall`             |
| `Lua.eval`              | `luerl:eval`            | `luaL_dostring`         |
| `Lua.eval!`             | `luerl:eval`            | `luaL_dostring`         |
| `Lua.eval_file`         | `luerl:evalfile`        | `luaL_dofile`           |
| `Lua.eval_file!`        | `luerl:evalfile`        | `luaL_dofile`           |
| `Lua.gc`                | `luerl:gc`              | `lua_gc`                |
| `Lua.load`              | `luerl:load`            | `luaL_loadstring`       |
| `Lua.load!`             | `luerl:load`            | `luaL_loadstring`       |
| `Lua.load_file`         | `luerl:loadfile`        | `luaL_loadfile`         |
| `Lua.load_file!`        | `luerl:loadfile`        | `luaL_loadfile`         |
| `Lua.get_global`        | `luerl:get_global_key`  | `lua_getglobal`         |
| `Lua.get_table`         | `luerl:get_table`       | `lua_gettable`          |
| `Lua.set_global`        | `luerl:set_global_key`  | `lua_setglobal`         |
| `Lua.set_table`         | `luerl:set_table`       | `lua_settable`          |

Installation
------------

Add `exlua` to your list of dependencies in your project's `mix.exs` file:

```elixir
defp deps do
  [{:exlua, "~> 0.3.0"},
   {:luerl, github: "bendiken/luerl", branch: "exlua",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```

Alternatively, to pull in the dependency directly from a Git tag:

```elixir
defp deps do
  [{:exlua, github: "bendiken/exlua", tag: "0.3.0"},
   {:luerl, github: "bendiken/luerl", branch: "exlua",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```

Alternatively, to pull in the dependency directly from a Git branch:

```elixir
defp deps do
  [{:exlua, github: "bendiken/exlua", branch: "master"},
   {:luerl, github: "bendiken/luerl", branch: "exlua",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```
