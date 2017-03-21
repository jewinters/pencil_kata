defmodule PaperTest do
  use ExUnit.Case
  doctest Paper

  test "A paper can be written on and read" do
    paper = Paper.new()

    Paper.write(paper, "read me")
    assert (Paper.read(paper) == "read me")
  end

  test "A paper will append new text to existing text when written on" do
    paper = Paper.new("Existing text")

    Paper.write(paper, " plus new text")
    assert (Paper.read(paper) == "Existing text plus new text")
  end
end