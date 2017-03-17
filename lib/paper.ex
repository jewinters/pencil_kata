defmodule Paper do
  @moduledoc false

  def new(text \\ "") do
    {:ok, pid} = Agent.start_link fn -> text end
    pid
  end

  def read(paper) do
    Agent.get paper, fn state -> state end
  end

  def write(paper, text) do
    Agent.update paper, fn state -> state <> text end
  end

end