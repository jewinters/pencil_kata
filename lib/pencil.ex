defmodule Pencil do
  @moduledoc false

  def new(durability, length \\ 1) do
    {:ok, pencil} = Agent.start_link fn -> %{durability: durability, max_durability: durability, length: length} end
    pencil
  end

  def write(pencil, paper, text) do
    Agent.update pencil, fn state ->
      {remaining_durability, written_text} = write_characters state[:durability], String.codepoints(text)
      Paper.write paper, written_text
      %{state | durability: remaining_durability}
    end
  end

  def write_characters(durability, characters) do
    write_characters durability, characters, ""
  end

  def write_characters(durability, [head | tail], written_text) do
    cond do
      head =~ ~r/\s/                       -> write_characters durability, tail, written_text <> head
      head =~ ~r/[A-Z]/ && durability > 1  -> write_characters durability - 2, tail, written_text <> head
      head =~ ~r/[A-Z]/ && durability <= 1 -> write_characters 0, tail, written_text <> " "
      durability > 0                       -> write_characters durability - 1, tail, written_text <> head
      true                                 -> write_characters 0, tail, written_text <> " "
    end
  end

  def write_characters(durability, [], written_text) do
    {durability, written_text}
  end

  def sharpen(pencil) do
    Agent.update pencil, fn state ->
      cond do
        state[:length] > 0 -> %{state | durability: state[:max_durability], length: state[:length] - 1}
        true               -> state
      end
    end
  end

  def get_durability(pencil) do
    Agent.get pencil, fn state -> state[:durability] end
  end

  def get_length(pencil) do
    Agent.get pencil, fn state -> state[:length] end
  end
end