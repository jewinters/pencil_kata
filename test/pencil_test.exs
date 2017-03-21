defmodule PencilTest do
  use ExUnit.Case
  doctest Pencil

  test "a pencil can write some text" do
    pencil = Pencil.new(100)
    paper = Paper.new()
    Pencil.write(pencil, paper, "hello")
    assert (Paper.read(paper) == "hello")
  end

  test "a new pencil has a specified durability" do
    pencil = Pencil.new(100)
    assert (Pencil.get_durability(pencil) == 100)
  end

  test "a pencil will lose durability when it writes" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "hello")
    assert (Pencil.get_durability(pencil) == 5)
  end

  test "a pencil will write spaces when it runs out of durability" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "dodecahedron")

    assert (Pencil.get_durability(pencil) == 0)
    assert (Paper.read(paper) == "dodecahedr  ")
  end

  test "a pencil can be sharpened to restore durability to its original value" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "dodecahedron")

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
    paper = Paper.new()
    Pencil.write(pencil, paper, "dodecahedron")

    Pencil.sharpen(pencil)

    assert (Pencil.get_durability(pencil) == 0)
  end

  test "a pencil will not deplete durability when writing spaces" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "hello, world!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (Paper.read(paper) == "hello, worl  ")
  end

  test "a pencil will not deplete durability when writing newlines" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "hello,\nworld!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (Paper.read(paper) == "hello,\nworl  ")
  end

  test "a pencil will not deplete durability when writing tabs" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "hello,\tworld!")
    assert (Pencil.get_durability(pencil) == 0)
    assert (Paper.read(paper) == "hello,\tworl  ")
  end

  test "a pencil uses twice as much durability to write capital letters" do
    pencil = Pencil.new(10)
    paper = Paper.new()
    Pencil.write(pencil, paper, "HELLO")
    assert (Pencil.get_durability(pencil) == 0)
  end

  test "a pencil will fail to write a capital letter if it has only one durability" do
    pencil = Pencil.new(1)
    paper = Paper.new()
    Pencil.write(pencil, paper, "A")
    assert (Paper.read(paper) == " ")
  end
end