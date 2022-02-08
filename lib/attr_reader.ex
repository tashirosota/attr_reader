defmodule AttrReader do
  @moduledoc """
  Can define module attributes getter automatically.
  """
  @reserved_attributes Module.reserved_attributes() |> Map.keys()

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
  """
  @spec __using__(any) ::
          {:@, [{:context, AttrReader} | {:import, Kernel}, ...],
           [{:before_compile, [...], [...]}, ...]}
  defmacro __using__(_opts \\ nil) do
    quote do
      @before_compile AttrReader
    end
  end

  @spec __before_compile__(atom | %{:module => atom, optional(any) => any}) :: list
  defmacro __before_compile__(env) do
    attributes_in(env.module)
    |> REnum.reject(&(&1 in @reserved_attributes))
    |> REnum.map(fn attribute ->
      quote do
        @doc """
        Gets @#{unquote(attribute)}.
        ## Examples
            iex> #{unquote(env.module)}.#{unquote(attribute)}()
            #{unquote(Module.get_attribute(env.module, attribute))}
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
  @spec define(tuple, any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro define(attribute, value \\ nil) do
    attr_key = elem(attribute, 2) |> RList.first() |> elem(0)

    quote do
      @attar_value unquote(value)
      @doc """
      Gets @#{unquote(attr_key)}.
      ## Examples
          iex> #{unquote(__MODULE__)}.#{unquote(attr_key)}()
          #{unquote(value)}
      """
      def unquote(attr_key)() do
        @attar_value
      end
    end
  end

  defp attributes_in(module) when is_atom(module) do
    {set, _} = :elixir_module.data_tables(module)
    :ets.select(set, [{{:"$1", :_, :_}, [{:is_atom, :"$1"}], [:"$1"]}])
  end
end
