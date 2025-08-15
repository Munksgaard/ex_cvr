defmodule CVR do
  @moduledoc """
  Validates and generates Danish CVR-numbers.

  Every Danish company is registered in [CVR] ("Det Central
  Virksomhedsregister"/"The Central Business Registry") with a unique
  CVR-number. This library can validate a given CVR-number according to the
  modulo-11 rule and generate random ones (if `StreamData` is present).

  [CVR]: https://en.wikipedia.org/wiki/Central_Business_Register

  ## The modulo-11 rule

  Like Danish [CPR-numbers], CVR-numbers are generated according to a [modulo-11
  rule]. For CVR-numbers, the first 7 digits is a sequential counter and the
  eighth digit is a control digit. This means that not all 8-digit numbers are
  valid CVR-numbers. For instance, [24256790] is a valid CVR-number, because the
  sum of multiplying each digit with a predefined weight divides evenly with 11.
  Similarly 24256791 is not a valid CVR number because the modulo-11 test
  does not hold.

  [CPR-numbers]: https://en.wikipedia.org/wiki/Personal_identification_number_(Denmark)
  [modulo-11 rule]: https://web.archive.org/web/20120917151518/http://www.erhvervsstyrelsen.dk/modulus_11
  [24256790]: https://datacvr.virk.dk/enhed/virksomhed/24256790

  """

  alias CVR.Util

  @modulo_11_weights [2, 7, 6, 5, 4, 3, 2, 1]

  @doc ~S"""
  Validates whether a given CVR number is valid or not.

  This function accepts both integers and strings as inputs. The strings must
  either contain a number, or a number preceeded by either "DK" or "DK-". The
  "DK-12345678" format is commonly used in systems that can handle different
  company registration IDs from different countries.

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

    Requires [`StreamData`](https://hexdocs.pm/stream_data). The generated
    CVR-numbers are guaranteed to be valid.
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
