defmodule Cosmos.DateTest do
  use ExUnit.Case

  alias Cosmos.Date

  describe "pad_dates/1" do
    test "padding sparse dates" do
      dates = [~D[2025-03-15], ~D[2025-03-17], ~D[2025-03-19]]

      assert Date.pad_dates(dates) == [
               ~D[2025-03-15],
               ~D[2025-03-16],
               ~D[2025-03-17],
               ~D[2025-03-18],
               ~D[2025-03-19]
             ]
    end

    test "do nothing for empty dates" do
      assert Date.pad_dates([]) == []
    end
  end
end
