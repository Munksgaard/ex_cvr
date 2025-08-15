defmodule CVRTest do
  use ExUnit.Case
  doctest CVR

  import ExUnitProperties

  @sample_valid_cvr_numbers [10_000_009, 99_999_993, 24_256_790]

  @sample_invalid_cvr_numbers [10_000_008, 10_000_010, 99_999_992, 99_999_994, 24_256_791]

  describe "valid?/1" do
    test "correctly reports sample valid CVR numbers as valid" do
      for cvr_number <- @sample_valid_cvr_numbers do
        assert CVR.valid?(cvr_number)
      end
    end

    test "correctly reports sample invalid CVR numbers as invalid" do
      for cvr_number <- @sample_invalid_cvr_numbers do
        refute CVR.valid?(cvr_number)
      end
    end
  end

  property "generate/0 generates valid CVR numbers" do
    check all cvr_number <- CVR.generate() do
      assert CVR.valid?(cvr_number)
    end
  end
end
