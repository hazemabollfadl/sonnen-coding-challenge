defmodule VillainSelection.Validation do
  @moduledoc """
  Validation functions for the VillainSelection module.
  """

  @spec validate_malice(list(map())) :: :ok | {:error, String.t()}
  def validate_malice(radar) do
    radar
    |> Enum.flat_map(& &1["villains"])
    |> Enum.find(fn villain ->
      villain["malice"] && (villain["malice"] < 0 or villain["malice"] > 100)
    end)
    |> case do
      nil -> :ok
      _ -> {:error, "invalid malice value"}
    end
  end

  defp sort_villains(villains, attack_modes) do
    if "prioritize-vader" in attack_modes do
      Enum.sort_by(villains, fn villain ->
        if villain["costume"] == "Darth Vader" do
          {0, -villain["malice"]}
        else
          {1, -villain["malice"]}
        end
      end)
    else
      Enum.sort_by(villains, & &1["malice"], :desc)
    end
  end

  @spec validate_radar(list(map())) :: :ok | {:error, String.t()}
  def validate_radar(radar) do
    Enum.find(radar, fn area ->
      is_nil(area["position"]) or is_nil(area["villains"])
    end)
    |> case do
      nil -> :ok
      _ -> {:error, "missing radar value"}
    end
  end

  @spec validate_and_sort_villains(list(map()), list(String.t())) :: :ok | {:error, String.t()}
  def validate_and_sort_villains(radar, attack_modes) do
    with :ok <- validate_radar(radar),
         :ok <- validate_malice(radar) do
      sorted_radar =
        Enum.map(radar, fn area ->
          sorted_villains = sort_villains(area["villains"], attack_modes)
          Map.put(area, "villains", sorted_villains)
        end)

      {:ok, sorted_radar}
    else
      error -> error
    end
  end
end
