defmodule Caju.CardTransactionsTest do
  use Caju.DataCase, async: true

  import Caju.Factories.AccountFactory

  alias Caju.CardTransactions
  alias Caju.CardTransactions.Accounts.Account
  alias Caju.CardTransactions.Transactions.Transaction
  alias Caju.Repo

  describe "authorize/1" do
    setup do
      account = insert(:account, food_balance: 100, meal_balance: 200, cash_balance: 300)

      {:ok, account: account}
    end

    test "should return approved response code when balance is available for food transaction", %{
      account: account
    } do
      account_id = account.id

      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account_id,
        "amount" => 100,
        "merchant" => "merchant",
        "mcc" => "5411"
      }

      assert CardTransactions.authorize(payload) == "00"

      %Transaction{account_id: ^account_id, amount: 100, merchant: "merchant", mcc: "5411"} =
        Repo.get(Transaction, payload["id"])

      %Account{food_balance: 0, meal_balance: 200, cash_balance: 300} =
        Repo.get(Account, account_id)
    end

    test "should return approved response code when only cash balance is available for food transaction",
         %{
           account: account
         } do
      account_id = account.id

      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account_id,
        "amount" => 250,
        "merchant" => "merchant",
        "mcc" => "5411"
      }

      assert CardTransactions.authorize(payload) == "00"

      %Transaction{account_id: ^account_id, amount: 250, merchant: "merchant", mcc: "5411"} =
        Repo.get(Transaction, payload["id"])

      %Account{food_balance: 100, meal_balance: 200, cash_balance: 50} =
        Repo.get(Account, account_id)
    end

    test "should return approved response code when balance is available for meal transaction", %{
      account: account
    } do
      account_id = account.id

      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account_id,
        "amount" => 200,
        "merchant" => "merchant",
        "mcc" => "5812"
      }

      assert CardTransactions.authorize(payload) == "00"

      %Transaction{account_id: ^account_id, amount: 200, merchant: "merchant", mcc: "5812"} =
        Repo.get(Transaction, payload["id"])

      %Account{food_balance: 100, meal_balance: 0, cash_balance: 300} =
        Repo.get(Account, account_id)
    end

    test "should return approved response code when only cash balance is available for meal transaction",
         %{
           account: account
         } do
      account_id = account.id

      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account_id,
        "amount" => 299,
        "merchant" => "merchant",
        "mcc" => "5812"
      }

      assert CardTransactions.authorize(payload) == "00"

      %Transaction{account_id: ^account_id, amount: 299, merchant: "merchant", mcc: "5812"} =
        Repo.get(Transaction, payload["id"])

      %Account{food_balance: 100, meal_balance: 200, cash_balance: 1} =
        Repo.get(Account, account_id)
    end

    test "should return approved response code when balance is available for cash transaction", %{
      account: account
    } do
      account_id = account.id

      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account_id,
        "amount" => 200,
        "merchant" => "merchant",
        "mcc" => "6011"
      }

      assert CardTransactions.authorize(payload) == "00"

      %Transaction{account_id: ^account_id, amount: 200, merchant: "merchant", mcc: "6011"} =
        Repo.get(Transaction, payload["id"])

      %Account{food_balance: 100, meal_balance: 200, cash_balance: 100} =
        Repo.get(Account, account_id)
    end

    test "should decline a transaction when balance is insufficient for food transaction", %{
      account: account
    } do
      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account.id,
        "amount" => 9999,
        "merchant" => "Food merchant",
        "mcc" => "1234"
      }

      assert CardTransactions.authorize(payload) == "51"
    end

    test "should decline a transaction when balance is insufficient for meal transaction", %{
      account: account
    } do
      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account.id,
        "amount" => 9999,
        "merchant" => "Food merchant",
        "mcc" => "1234"
      }

      assert CardTransactions.authorize(payload) == "51"
    end

    test "should decline a transaction when balance is insufficient for cash transaction", %{
      account: account
    } do
      payload = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account.id,
        "amount" => 9999,
        "merchant" => "cash merchant",
        "mcc" => "1234"
      }

      assert CardTransactions.authorize(payload) == "51"
    end

    test "should return error code when payload is invalid" do
      invalid_payload = %{"invalid" => "data"}
      assert CardTransactions.authorize(invalid_payload) == "07"
    end

    test "should return error code when account does not exist" do
      invalid_account_id = Ecto.UUID.generate()

      payload = %{
        "id" => "transaction_id",
        "account_id" => invalid_account_id,
        "amount" => 100,
        "merchant" => "merchant",
        "mcc" => "mcc"
      }

      assert CardTransactions.authorize(payload) == "07"
    end
  end
end
