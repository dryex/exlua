ExLua
=====

[![Hex.pm package](https://img.shields.io/hexpm/v/exlua.svg)](https://hex.pm/packages/exlua)
[![Hex.pm downloads](https://img.shields.io/hexpm/dt/exlua.svg)](https://hex.pm/packages/exlua)
[![Hex.pm license](https://img.shields.io/hexpm/l/exlua.svg)](https://unlicense.org/)
[![Travis CI build status](https://img.shields.io/travis/bendiken/exlua/master.svg)](https://travis-ci.org/bendiken/exlua)
[![Coveralls.io code coverage](https://img.shields.io/coveralls/bendiken/exlua/master.svg)](https://coveralls.io/github/bendiken/exlua)
[![Gratipay donations](https://img.shields.io/gratipay/user/bendiken.svg)](https://gratipay.com/~bendiken/)

Lua for Elixir, based on [Luerl](https://github.com/rvirding/luerl).

Examples
--------

```elixir
  [42.0] = Lua.State.new |> Lua.eval!("return 6 * 7")
```

Reference
---------

https://hexdocs.pm/exlua/

### Types

| ExLua (Elixir)        | Luerl (Erlang)        | Lua                   |
| :-------------------- | :-------------------- | :-------------------- |
| atom                  | atom                  | -                     |
| `nil                  | `'nil'`               | `nil`                 |
| `true`, `false`       | `'true'`, `'false'`   | `true`, `false`       |
| integer               | integer               | number                |
| float                 | float                 | number                |
| string (binary)       | binary                | string                |
| {:function, ...}      | #function{...}        | function              |
| {:userdata, ...}      | #userdata{...}        | userdata              |
| {:thread, ...}        | #thread{...}          | thread                |
| {:table, ...}         | #table{...}           | table                 |

### Functions

| ExLua (Elixir)        | Luerl (Erlang)        | Lua (C)               |
| :-------------------- | :-------------------- | :-------------------- |
| `Lua.Error`           | `{:error, ...}`       | `luaL_error`          |
| `Lua.State.new`       | `luerl:init`          | `luaL_newstate`       |
| `Lua.call_chunk!`     | `luerl:call_chunk`    | `lua_pcall`           |
| `Lua.call_function!`  | `luerl:call_function` | `lua_pcall`           |
| `Lua.eval`            | `luerl:eval`          | `luaL_dostring`       |
| `Lua.eval!`           | `luerl:eval`          | `luaL_dostring`       |
| `Lua.eval_file`       | `luerl:evalfile`      | `luaL_dofile`         |
| `Lua.eval_file!`      | `luerl:evalfile`      | `luaL_dofile`         |
| `Lua.gc`              | `luerl:gc`            | `lua_gc`              |
| `Lua.load`            | `luerl:load`          | `luaL_loadstring`     |
| `Lua.load!`           | `luerl:load`          | `luaL_loadstring`     |
| `Lua.load_file`       | `luerl:loadfile`      | `luaL_loadfile`       |
| `Lua.load_file!`      | `luerl:loadfile`      | `luaL_loadfile`       |
| `Lua.set_table`       | `luerl:set_table`     | `lua_settable`        |


Installation
------------

Add `exlua` to your list of dependencies in your project's `mix.exs` file:

```elixir
defp deps do
  [{:exlua, "~> 0.2.0"},
   {:luerl, github: "rvirding/luerl", tag: "v0.3",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```

Alternatively, to pull in the dependency directly from a Git tag:

```elixir
defp deps do
  [{:exlua, github: "bendiken/exlua", tag: "0.2.0"},
   {:luerl, github: "rvirding/luerl", tag: "v0.3",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```

Alternatively, to pull in the dependency directly from a Git branch:

```elixir
defp deps do
  [{:exlua, github: "bendiken/exlua", branch: "master"},
   {:luerl, github: "rvirding/luerl", tag: "v0.3",
            compile: "make && cp src/luerl.app.src ebin/luerl.app"}]
end
```
