defmodule CVR.PNumber do
  @moduledoc """
  Documentation for `CVR.PNumber`.

  P-units use the same modulo-11 verification method as `m:CVR`-numbers, but
  they are 10 digits long instead of 8.

  Note that, due to an error when P-numbers were first introduced, there are two
  different sets of weights in use depending on whether the P-number is above or
  below 1006959421. This library will correctly validate and generate both.

  For more information, see the note at the bottom of [this archived description
  of the modulus 11 test].

  [this archived description of the modulus 11 test]: https://web.archive.org/web/20120917151518/http://www.erhvervsstyrelsen.dk/modulus_11
  """

  alias CVR.Util

  @old_weights [1, 5, 6, 7, 3, 6, 4, 8, 9, 1]
  @new_weights [4, 3, 2, 7, 6, 5, 4, 3, 2, 1]

  @cutoff 1_006_959_421

  @doc ~S"""
  Validates whether a given P number is valid or not.

  Danish P-numbers follow a so-called "modulo 11" format.

  ## Usage

      iex> CVR.PNumber.valid?("1029829825")
      true

      iex> CVR.PNumber.valid?(1029829825)
      true

      iex> CVR.PNumber.valid?("Not a number")
      false

      iex> CVR.PNumber.valid?("1029829824")
      false

      iex> CVR.PNumber.valid?(1029829824)
      false

      iex> CVR.PNumber.valid?(10000000)
      false
  """

  @spec valid?(String.t() | integer()) :: boolean()
  def valid?(p_number) when is_integer(p_number) do
    cond do
      p_number < 1_000_000_000 or p_number > 9_999_999_999 -> false
      p_number <= @cutoff -> Util.control_digit(p_number, @old_weights) == 0
      true -> Util.control_digit(p_number, @new_weights) == 0
    end
  end

  def valid?(p_number) when is_binary(p_number) do
    String.length(p_number) == 10 &&
      p_number
      |> String.to_integer()
      |> valid?()
  end

  if Code.ensure_loaded?(StreamData) do
    import ExUnitProperties

    @doc ~S"""
    Generate a random P-number.

    Requires [`StreamData`](https://hexdocs.pm/stream_data). The generated
    P-numbers are guaranteed to be valid.
    """
    @spec generate :: StreamData.t(pos_integer())
    def generate do
      StreamData.frequency([{1, generate_old()}, {9, generate_new()}])
    end

    defp generate_old do
      gen all candidate <- StreamData.integer(100_000_000..Integer.floor_div(@cutoff, 10)),
              control_digit = Util.control_digit(candidate, @old_weights) do
        candidate * 10 + control_digit
      end
    end

    defp generate_new do
      gen all candidate <- StreamData.integer((Integer.floor_div(@cutoff, 10) + 1)..999_999_999),
              control_digit = Util.control_digit(candidate, @new_weights) do
        candidate * 10 + control_digit
      end
    end
  end
end
