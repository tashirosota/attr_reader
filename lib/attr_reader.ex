defmodule AttrReader do
  @reserved_attributes Module.reserved_attributes() |> Map.keys()
  defmacro __using__(_opts \\ []) do
    quote do
      @before_compile AttrReader
    end
  end

  defmacro __before_compile__(env) do
    attributes_in(env.module)
    |> REnum.reject(&(&1 in @reserved_attributes))
    |> REnum.map(fn attribute ->
      quote do
        def unquote(attribute)() do
          unquote(Module.get_attribute(env.module, attribute))
        end
      end
    end)
  end

  defmacro define(attribute, value \\ nil) do
    attr_key = elem(attribute, 2) |> RList.first() |> elem(0)

    quote do
      @attar_value unquote(value)
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
