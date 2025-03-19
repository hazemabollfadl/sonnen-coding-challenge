defmodule VillainSelection do
  use Application

  def start(_type, _args) do
    VillainSelection.select("Default_value")
    Supervisor.start_link([], strategy: :one_for_one)
  end

  @spec select(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def select(_input) do
    IO.puts("hello")
  end
end
