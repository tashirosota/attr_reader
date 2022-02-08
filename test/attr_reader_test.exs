defmodule AttrReaderTest do
  use ExUnit.Case
  doctest AttrReader

  defmodule UseAttrReader do
    @a :a_value
    use AttrReader
    @b :b_value
  end

  defmodule UseAttrReaderMacro do
    AttrReader.define(@a)
    AttrReader.define(@b, :b_value)
    AttrReader.define(@c, :c_value)
  end

  test "use" do
    assert UseAttrReader.a() == :a_value
    assert UseAttrReader.b() == :b_value
  end

  test "attr_reader/2" do
    assert UseAttrReaderMacro.a() == nil
    assert UseAttrReaderMacro.b() == :b_value
    assert UseAttrReaderMacro.c() == :c_value
    assert UseAttrReaderMacro.a() == nil
    assert UseAttrReaderMacro.b() == :b_value
    assert UseAttrReaderMacro.c() == :c_value
  end
end
