defmodule VillainSelection.Helpers do
  @moduledoc """
  Helper functions for the VillainSelection module.
  """

  @spec filter_villains(list(map())) :: list(map())
  def filter_villains(radar) do
    Enum.map(radar, fn area ->
      villains =
        Enum.reject(area["villains"], fn villain -> villain["costume"] == "Donald Duck" end)

      Map.put(area, "villains", villains)
    end)
  end

  @spec select_area(list(map()), list(String.t())) :: {:ok, map()} | {:error, String.t()}
  def select_area(radar, ["closest-first" | _]) do
    {:ok, Enum.min_by(radar, &distance(&1["position"]))}
  end

  def select_area(radar, ["furthest-first" | _]) do
    {:ok, Enum.max_by(radar, &distance(&1["position"]))}
  end

  def select_area(radar, ["avoid-crossfire" | _]) do
    filtered_radar =
      Enum.reject(radar, fn area ->
        Enum.any?(area["villains"], fn villain -> villain["costume"] == "Donald Duck" end)
      end)

    {:ok, Enum.max_by(filtered_radar, &length(&1["villains"]))}
  end

  def select_area(radar, ["prioritize-vader" | _]) do
    filtered_radar =
      Enum.filter(radar, fn area ->
        Enum.any?(area["villains"], fn villain -> villain["costume"] == "Darth Vader" end)
      end)

    {:ok, Enum.min_by(filtered_radar, &distance(&1["position"]))}
  end

  def select_area(_, _), do: {:error, "unsupported attack mode"}

  @spec distance(map()) :: float()
  def distance(%{"x" => x, "y" => y}) do
    :math.sqrt(x * x + y * y)
  end
end
