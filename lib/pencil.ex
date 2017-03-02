defmodule Pencil do
  @moduledoc false

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def new(durability, length \\ 1) do
    {:ok, pid} = Pencil.start_link
    Pencil.put(pid, "durability", durability)
    Pencil.put(pid, "max_durability", durability)
    Pencil.put(pid, "length", length)
    pid
  end

  def get(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  def put(pid, key, value) do
    Agent.update(pid, &Map.put(&1, key, value))
  end

  def write(pid, text) do
    durability = get_durability(pid)

    {remaining_durability, written_text} = write_characters(durability, String.codepoints(text))
    set_durability(pid, remaining_durability)
    written_text
  end

  def write_characters(durability, characters) do
    write_characters(durability, characters, "")
  end

  def write_characters(durability, [head | tail], written_text) do
    cond do
      head =~ ~r/\s/                       -> write_characters(durability, tail, written_text <> head)
      head =~ ~r/[A-Z]/ && durability > 1  -> write_characters(durability - 2, tail, written_text <> head)
      head =~ ~r/[A-Z]/ && durability <= 1 -> write_characters(0, tail, written_text <> " ")
      durability > 0                       -> write_characters(durability - 1, tail, written_text <> head)
      true                                 -> write_characters(0, tail, written_text <> " ")
    end
  end

  def write_characters(durability, [], written_text) do
    {durability, written_text}
  end

  def sharpen(pid) do
    new_length = get_length(pid) - 1
    if (new_length >= 0) do
      set_durability(pid, get_max_durability(pid))
      set_length(pid, new_length)
    end
  end

  def get_durability(pid) do
    Pencil.get(pid, "durability")
  end

  def get_max_durability(pid) do
    Pencil.get(pid, "max_durability")
  end

  def set_durability(pid, durability) do
    Pencil.put(pid, "durability", durability)
  end

  def get_length(pid) do
    Pencil.get(pid, "length")
  end

  def set_length(pid, length) do
    Pencil.put(pid, "length", length)
  end
end