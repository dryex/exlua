ExLua
=====

[![Hex.pm package](https://img.shields.io/hexpm/v/exlua.svg)](https://hex.pm/packages/exlua)
[![Hex.pm downloads](https://img.shields.io/hexpm/dt/exlua.svg)](https://hex.pm/packages/exlua)
[![Hex.pm license](https://img.shields.io/hexpm/l/exlua.svg)](https://unlicense.org/)
[![Travis CI build status](https://img.shields.io/travis/bendiken/exlua/master.svg)](https://travis-ci.org/bendiken/exlua)
[![Coveralls.io code coverage](https://img.shields.io/coveralls/bendiken/exlua/master.svg)](https://coveralls.io/github/bendiken/exlua)
[![Gratipay](https://img.shields.io/gratipay/user/bendiken.svg)](https://gratipay.com/~bendiken/)

Lua for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `exlua` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exlua, "~> 0.1.0"}]
    end
    ```

  2. Ensure `exlua` is started before your application:

    ```elixir
    def application do
      [applications: [:exlua]]
    end
    ```
