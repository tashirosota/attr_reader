defmodule AttrReaderTest do
  use ExUnit.Case
  doctest AttrReader

  defmodule UseAttrReader do
    @a :a_value
    @b :b_value
    use AttrReader
    @c [:c_value]
  end

  defmodule UseAttrReaderMacro do
    AttrReader.define(@a)
    AttrReader.define(@b, :b_value)
    AttrReader.define(@c, :c_value)
    AttrReader.define(@d, [:d_value])
  end

  defmodule UseAttrReaderOnlyA do
    use AttrReader, only: [:a]
    @a :a_value
    @b :b_value
    @c [:c_value]
  end

  defmodule UseAttrReaderExceptA do
    use AttrReader, except: [:a]
    @a :a_value
    @b :b_value
    @c [:c_value]
  end

  test "use" do
    assert UseAttrReader.a() == :a_value
    assert UseAttrReader.b() == :b_value
    assert UseAttrReader.c() == [:c_value]

    assert UseAttrReaderOnlyA.a() == :a_value

    assert_raise UndefinedFunctionError, fn ->
      UseAttrReaderOnlyA.b()
    end

    assert_raise UndefinedFunctionError, fn ->
      UseAttrReaderOnlyA.c()
    end

    assert_raise UndefinedFunctionError, fn ->
      UseAttrReaderExceptA.a()
    end

    assert UseAttrReaderExceptA.b() == :b_value
    assert UseAttrReaderExceptA.c() == [:c_value]
  end

  test "attr_reader/2" do
    assert UseAttrReaderMacro.a() == nil
    assert UseAttrReaderMacro.b() == :b_value
    assert UseAttrReaderMacro.c() == :c_value
    assert UseAttrReaderMacro.a() == nil
    assert UseAttrReaderMacro.b() == :b_value
    assert UseAttrReaderMacro.c() == :c_value
    assert UseAttrReaderMacro.d() == [:d_value]
  end
end
