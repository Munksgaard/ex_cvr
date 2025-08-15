defmodule CVR.Util do
  @moduledoc false

  @doc false
  def control_digit(candidate, weights) do
    candidate
    |> Integer.digits()
    |> Enum.zip_with(weights, &Kernel.*/2)
    |> Enum.sum()
    |> Integer.mod(11)
    |> case do
      1 -> nil
      0 -> 0
      n when n < 11 -> 11 - n
    end
  end
end
