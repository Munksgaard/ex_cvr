defmodule CVR do
  @moduledoc """
  Documentation for `CVR`.
  """

  alias CVR.Util

  @modulo_11_weights [2, 7, 6, 5, 4, 3, 2, 1]

  @doc ~S"""
  Validates whether a given CVR number is valid or not.

  Danish CVR-numbers follow a so-called "modulo 11" format.

  ## Usage

      iex> CVR.valid?("DK24256790")
      true

      iex> CVR.valid?("DK-24256790")
      true

      iex> CVR.valid?(24256790)
      true

      iex> CVR.valid?("Not a number")
      false

      iex> CVR.valid?("DK-24256791")
      false

      iex> CVR.valid?(24256791)
      false

      iex> CVR.valid?(10000000)
      false
  """

  @spec valid?(String.t() | integer()) :: boolean()
  def valid?(cvr_number) when is_integer(cvr_number) do
    cvr_number >= 10_000_000 and
      cvr_number <= 99_999_999 and
      Util.control_digit(cvr_number, @modulo_11_weights) == 0
  end

  def valid?(<<"DK-", rest::binary>>), do: valid?(rest)
  def valid?(<<"DK", rest::binary>>), do: valid?(rest)

  def valid?(cvr_number) when is_binary(cvr_number) do
    String.length(cvr_number) == 8 &&
      cvr_number
      |> String.to_integer()
      |> valid?()
  end

  if Code.ensure_loaded?(StreamData) do
    import ExUnitProperties

    @doc ~S"""
    Generate a random CVR-number.

    The generated CVR-numbers are guaranteed to be valid.
    """
    @spec generate :: StreamData.t(pos_integer())
    def generate do
      # Follow the method described here:
      # https://web.archive.org/web/20120917151518/http://www.erhvervsstyrelsen.dk/modulus_11
      gen all candidate <- StreamData.integer(1_000_000..9_999_999),
              control_digit = Util.control_digit(candidate, @modulo_11_weights) do
        candidate * 10 + control_digit
      end
    end
  end
end
