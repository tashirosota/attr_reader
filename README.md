<!-- @format -->

[![hex.pm version](https://img.shields.io/hexpm/v/attr_reader.svg)](https://hex.pm/packages/attr_reader)
[![CI](https://github.com/tashirosota/attr_reader/actions/workflows/ci.yml/badge.svg)](https://github.com/tashirosota/attr_reader/actions/workflows/ci.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/tashirosota/attr_reader)

# AttrReader

In Elixir, Module variable is often used as a constant.
But I didn't want to bother to define a getter when I wanted to refer to it with Test code etc.
If you use AttrReader, you can use it without having to define the getter of the module attribute.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `attr_reader` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:attr_reader, "~> 0.1.0"}
  ]
end
```

## Usage

### Defines by `use`

```elixir
iex> defmodule UseAttrReader do
...>   @foo "foo"
...>   use AttrReader
...>   @bar :bar
...> end

iex> UseAttrReader.foo()
"foo"

iex> UseAttrReader.bar()
:bar
```

**with except**

```elixir
iex> defmodule UseAttrReader do
...>   @foo "foo"
...>   use AttrReader, except: [:foo]
...>   @bar :bar
...> end

iex> UseAttrReader.bar()
:bar

iex> UseAttrReader.foo()
** (UndefinedFunctionError)
```

**with only**

```elixir
iex> defmodule UseAttrReader do
...>   @foo "foo"
...>   use AttrReader, only: [:foo]
...>   @bar :bar
...> end

iex> UseAttrReader.foo()
"foo"

iex> UseAttrReader.bar()
** (UndefinedFunctionError)
```

### Defines by `macro`

```elixir
iex> defmodule UseAttrReaderMacro do
...>   require AttrReader
...>   AttrReader.define @foo
...>   AttrReader.define @bar, "bar"
...>   AttrReader.define @baz, :baz
...> end

iex> UseAttrReader.foo()
nil

iex> UseAttrReader.bar()
"bar"

iex> UseAttrReader.baz()
:baz
```
