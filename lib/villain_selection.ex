defmodule VillainSelection do
  @moduledoc """
  Module for selecting the next position to attack given several possible attack positions.
  """

  alias VillainSelection.Helpers
  alias VillainSelection.Validation

  @spec select(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def select(json_string) do
    case Jason.decode(json_string) do
      {:ok, data} ->
        attack_modes = data["attack_modes"]
        radar = data["radar"]

        case process_radar(radar, attack_modes) do
          {:ok, selected_area} ->
            result = %{
              "position" => selected_area["position"],
              "villains" => Enum.map(selected_area["villains"], & &1["costume"])
            }

            {:ok, Jason.encode!(result)}

          error ->
            error
        end

      {:error, decode_error} ->
        {:error, decode_error}
    end
  end

  defp process_radar(radar, attack_modes) do
    with {:ok, sorted_radar} <- Validation.validate_and_sort_villains(radar, attack_modes),
         filtered_radar <- Helpers.filter_villains(sorted_radar),
         {:ok, selected_area} <- Helpers.select_area(filtered_radar, attack_modes) do
      {:ok, selected_area}
    else
      error -> error
    end
  end
end
