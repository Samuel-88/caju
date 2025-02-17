defmodule Caju.CardTransactions.TransactionsTest do
  use Caju.DataCase, async: true

  import Caju.Factories.AccountFactory

  alias Caju.CardTransactions.Transactions
  alias Caju.CardTransactions.Transactions.Transaction
  alias Caju.Repo

  setup do
    account = insert(:account)

    {:ok, account: account}
  end

  describe "create/1" do
    test "should creates transaction when params are valid", %{account: account} do
      transaction_id = Ecto.UUID.generate()

      valid_params = %{
        id: transaction_id,
        amount: 100,
        merchant: "merchant",
        mcc: "1234",
        account_id: account.id
      }

      assert {:ok,
              %Transaction{id: ^transaction_id, amount: 100, merchant: "merchant", mcc: "1234"} =
                transaction} = Transactions.create(valid_params)
    end

    test "should return error when params are invalid" do
      invalid_params = %{amount: nil, description: "Invalid transaction"}

      assert {:error, changeset} = Transactions.create(invalid_params)
      assert changeset.valid? == false
    end
  end
end
