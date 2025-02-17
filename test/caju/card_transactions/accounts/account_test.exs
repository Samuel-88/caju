defmodule Caju.CardTransactions.Accounts.AccountTest do
  use Caju.DataCase, async: true

  alias Caju.CardTransactions.Accounts.Account

  describe "changeset/2" do
    test "should return a valid changeset when attrs are valid" do
      valid_attrs = %{
        food_balance: 100,
        meal_balance: 200,
        cash_balance: 300
      }

      changeset = Account.changeset(%Account{}, valid_attrs)

      assert changeset.valid?
    end

    test "should return a valid changeset when balances are not given" do
      valid_attrs = %{}

      changeset = Account.changeset(%Account{}, valid_attrs)

      assert changeset.valid?
    end

    test "should return an invalid changeset when balances are negative" do
      invalid_attrs = %{
        food_balance: -10,
        meal_balance: -20,
        cash_balance: -30
      }

      changeset = Account.changeset(%Account{}, invalid_attrs)

      refute changeset.valid?

      assert %{
               cash_balance: ["must be greater than or equal to 0"],
               food_balance: ["must be greater than or equal to 0"],
               meal_balance: ["must be greater than or equal to 0"]
             } = errors_on(changeset)
    end
  end
end
