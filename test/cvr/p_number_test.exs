defmodule CVR.PNumberTest do
  use ExUnit.Case
  doctest CVR.PNumber

  import ExUnitProperties

  @sample_valid_p_numbers [1_000_000_011, 9_999_999_996, 1_029_829_825]

  @sample_invalid_p_numbers [
    1_000_000_009,
    1_000_000_010,
    1_000_000_012,
    9_999_999_993,
    9_999_999_995,
    9_999_999_997,
    1_029_829_824
  ]

  describe "valid?/1" do
    test "correctly reports sample valid P numbers as valid" do
      for p_number <- @sample_valid_p_numbers do
        assert CVR.PNumber.valid?(p_number)
        assert CVR.PNumber.valid?(to_string(p_number))
      end
    end

    test "correctly reports sample invalid P numbers as invalid" do
      for p_number <- @sample_invalid_p_numbers do
        refute CVR.PNumber.valid?(p_number)
        refute CVR.PNumber.valid?(to_string(p_number))
      end
    end

    test "last P number with old weights is valid" do
      assert CVR.PNumber.valid?(1_006_959_421)
    end

    test "first P number with new weights is valid" do
      assert CVR.PNumber.valid?(1_006_959_438)
    end
  end

  property "generate/0 generates valid P numbers" do
    check all p_number <- CVR.PNumber.generate() do
      assert CVR.PNumber.valid?(p_number)
    end
  end
end
