defmodule AttrReader do
  @moduledoc """
  Can define module attributes getter automatically.
  """

  @doc """
  Defines getters for all custom module attributes if used.
  And writes getter docs.
  ## Examples
      iex> defmodule UseAttrReaderForDoc do
      ...>   @foo "foo"
      ...>   use AttrReader
      ...>   @bar :bar
      ...> end
      iex> UseAttrReaderForDoc.foo()
      "foo"
      iex> UseAttrReaderForDoc.bar()
      :bar

      iex> defmodule UseAttrReaderForDoc do
      ...>   @foo "foo"
      ...>   use AttrReader, only: [:foo]
      ...>   @bar :bar
      ...> end
      iex> UseAttrReaderForDoc.foo()
      "foo"
      iex> UseAttrReaderForDoc.bar()
      ** (UndefinedFunctionError) function AttrReaderTest.UseAttrReaderForDoc.bar/0 is undefined or private

      iex> defmodule UseAttrReaderForDoc do
      ...>   @foo "foo"
      ...>   use AttrReader, except: [:foo]
      ...>   @bar :bar
      ...> end
      iex> UseAttrReaderForDoc.bar()
      :bar
      iex> UseAttrReaderForDoc.foo()
      ** (UndefinedFunctionError) function AttrReaderTest.UseAttrReaderForDoc.foo/0 is undefined or private
  """
  defmacro __using__(opts \\ []) do
    only = opts |> Keyword.get(:only)
    except = opts |> Keyword.get(:except)

    quote do
      @before_compile_opts [only: unquote(only), except: unquote(except)]
      @before_compile AttrReader
    end
  end

  defmacro __before_compile__(env) do
    opts = Module.get_attribute(env.module, :before_compile_opts)
    only = opts |> Keyword.get(:only)
    except = opts |> Keyword.get(:except)

    attributes =
      Module.attributes_in(env.module)
      |> Enum.reject(&(&1 in (Map.keys(Module.reserved_attributes()) ++ [:before_compile_opts])))

    cond do
      only -> attributes |> Enum.filter(&(&1 in only))
      except -> attributes |> Enum.reject(&(&1 in except))
      true -> attributes
    end
    |> Enum.map(fn attribute ->
      quote do
        @doc """
        Gets @#{unquote(attribute)}.
        ## Examples
            iex> #{unquote(env.module)}.#{unquote(attribute)}()
            #{unquote(Module.get_attribute(env.module, attribute)) |> inspect()}
        """
        def unquote(attribute)() do
          unquote(Module.get_attribute(env.module, attribute))
        end
      end
    end)
  end

  @doc """
  Sets module attribute and defines getter.
  And writes getter docs.
  ## Examples
      iex> defmodule AttrReaderMacroForDoc do
      ...>   AttrReader.define @foo
      ...>   AttrReader.define @bar, "bar"
      ...>   AttrReader.define @baz, :baz
      ...> end
      iex> AttrReaderMacroForDoc.foo()
      nil
      iex> AttrReaderMacroForDoc.bar()
      "bar"
      iex> AttrReaderMacroForDoc.baz()
      :baz
  """
  defmacro define(attribute, value \\ nil) do
    [first | _] = elem(attribute, 2)
    attr_key = first |> elem(0)

    quote do
      @attar_value unquote(value)
      @doc """
      Gets @#{unquote(attr_key)}.
      ## Examples
          iex> #{unquote(__MODULE__)}.#{unquote(attr_key)}()
          #{unquote(value) |> inspect()}
      """
      def unquote(attr_key)() do
        @attar_value
      end
    end
  end
end
