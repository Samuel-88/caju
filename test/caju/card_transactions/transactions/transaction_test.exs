defmodule Caju.CardTransactions.Transactions.TransactionTest do
  use Caju.DataCase, async: true

  import Caju.Factories.AccountFactory

  alias Caju.CardTransactions.Transactions.Transaction

  @food_mcc "5411"
  @meal_mcc "5811"

  setup do
    account = insert(:account)

    valid_attrs = %{
      id: Ecto.UUID.generate(),
      amount: 100,
      merchant: "Merchant",
      mcc: "1234",
      account_id: account.id
    }

    invalid_attrs = %{id: nil, amount: nil, merchant: nil, mcc: nil, account_id: nil}

    {:ok, valid_attrs: valid_attrs, invalid_attrs: invalid_attrs}
  end

  test "should return a valid changeset when attributes are valid", %{valid_attrs: valid_attrs} do
    changeset = Transaction.changeset(%Transaction{}, valid_attrs)

    assert changeset.valid?
  end

  test "should return a valid changeset with overrided mcc when merchant is a food merchant",
       %{valid_attrs: valid_attrs} do
    food_merchants = ["*PAG123 Food SP", "*ZED Supermercado PB", "**UBER mercado"]

    for food_merchant <- food_merchants do
      valid_attrs = Map.merge(valid_attrs, %{mcc: "1234", merchant: food_merchant})
      changeset = Transaction.changeset(%Transaction{}, valid_attrs)

      assert changeset.valid?
      assert get_field(changeset, :mcc) == @food_mcc
    end
  end

  test "should return a valid changeset with overrided mcc when merchant is a meal merchant",
       %{valid_attrs: valid_attrs} do
    meal_merchants = ["*PAG123 meal SP", "*ZED restaurant PB", "**UBER cafe", "**99 eat"]

    for meal_merchant <- meal_merchants do
      valid_attrs = Map.merge(valid_attrs, %{mcc: "1234", merchant: meal_merchant})
      changeset = Transaction.changeset(%Transaction{}, valid_attrs)

      assert changeset.valid?
      assert get_field(changeset, :mcc) == @meal_mcc
    end
  end

  test "should return a valid changeset with original mcc when merchant is not a food or meal",
       %{valid_attrs: valid_attrs} do
    valid_attrs = Map.merge(valid_attrs, %{mcc: "1234", merchant: "Merchant"})
    changeset = Transaction.changeset(%Transaction{}, valid_attrs)

    assert changeset.valid?
    assert get_field(changeset, :mcc) == "1234"
  end

  test "should return an invalid changeset when attributes are invalid",
       %{invalid_attrs: invalid_attrs} do
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?

    assert %{
             account_id: ["can't be blank"],
             amount: ["can't be blank"],
             mcc: ["can't be blank"],
             merchant: ["can't be blank"]
           } = errors_on(changeset)
  end

  test "should return an invalid changeset when amount is not given", %{valid_attrs: valid_attrs} do
    invalid_attrs = Map.delete(valid_attrs, :amount)
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?
    assert errors_on(changeset) == %{amount: ["can't be blank"]}
  end

  test "should return an invalid changeset when merchant is not given",
       %{valid_attrs: valid_attrs} do
    invalid_attrs = Map.delete(valid_attrs, :merchant)
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?
    assert errors_on(changeset) == %{merchant: ["can't be blank"]}
  end

  test "should return an invalid changeset when mcc is not given", %{valid_attrs: valid_attrs} do
    invalid_attrs = Map.delete(valid_attrs, :mcc)
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?
    assert errors_on(changeset) == %{mcc: ["can't be blank"]}
  end

  test "should return an invalid changeset when id is not given", %{valid_attrs: valid_attrs} do
    invalid_attrs = Map.delete(valid_attrs, :id)
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?
    assert errors_on(changeset) == %{id: ["can't be blank"]}
  end

  test "should return an invalid changeset when account_id is not given",
       %{valid_attrs: valid_attrs} do
    invalid_attrs = Map.delete(valid_attrs, :account_id)
    changeset = Transaction.changeset(%Transaction{}, invalid_attrs)

    refute changeset.valid?
    assert errors_on(changeset) == %{account_id: ["can't be blank"]}
  end
end
