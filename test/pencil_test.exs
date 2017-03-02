defmodule PencilTest do
  use ExUnit.Case
  doctest Pencil

#  setup do
#    {:ok, pencil} = Pencil.start_link
#    {:ok, pencil: pencil}
#  end

#  test "behavior", %{pencil: pencil} do
#    assert Pencil.whatever(pencil, parameters)
#  end

  test "a pencil can write some text" do
    pencil = Pencil.new(100)
    assert (Pencil.write(pencil, "hello") == "hello")
  end

  test "a new pencil has a specified durability" do
    pencil = Pencil.new(100)
    assert (Pencil.get_durability(pencil) == 100)
  end

  test "a pencil will lose durability when it writes" do
    pencil = Pencil.new(10)
    Pencil.write(pencil, "hello")
    assert (Pencil.get_durability(pencil) == 5)
  end

  test "a pencil will write spaces when it runs out of durability" do
    pencil = Pencil.new(10)
    text = Pencil.write(pencil, "dodecahedron")

    assert (Pencil.get_durability(pencil) == 0)
    assert (text == "dodecahedr  ")
  end

  test "a pencil can be sharpened to restore durability to its original value" do
    pencil = Pencil.new(10)
    Pencil.write(pencil, "dodecahedron")

    Pencil.sharpen(pencil)

    assert (Pencil.get_durability(pencil) == 10)
  end

  test "a pencil can have a specified length" do
    pencil = Pencil.new(10, 2)
    assert (Pencil.get_length(pencil) == 2)
  end

  test "a pencil will become shorter if it is sharpened" do
    pencil = Pencil.new(10, 2)
    Pencil.sharpen(pencil)

    assert (Pencil.get_length(pencil) == 1)
  end

  test "a pencil can not be sharpened when its length is zero" do
    pencil = Pencil.new(10, 0)
    Pencil.write(pencil, "dodecahedron")

    Pencil.sharpen(pencil)

    assert (Pencil.get_durability(pencil) == 0)
  end

  test "a pencil will not deplete durability when writing spaces" do
    pencil = Pencil.new(10)
    text = Pencil.write(pencil, "hello, world!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (text == "hello, worl  ")
  end

  test "a pencil will not deplete durability when writing newlines" do
    pencil = Pencil.new(10)
    text = Pencil.write(pencil, "hello,\nworld!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (text == "hello,\nworl  ")
  end

  test "a pencil will not deplete durability when writing tabs" do
    pencil = Pencil.new(10)
    text = Pencil.write(pencil, "hello,\tworld!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (text == "hello,\tworl  ")
  end

  test "a pencil uses twice as much durability to write capital letters" do
    pencil = Pencil.new(10)
    Pencil.write(pencil, "HELLO")
    assert (Pencil.get_durability(pencil) == 0)
  end

  test "a pencil will fail to write a capital letter if it has only one durability" do
    pencil = Pencil.new(1)
    text = Pencil.write(pencil, "A")
    assert (text == " ")
  end
end