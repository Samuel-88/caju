defmodule Caju.CardTransactions.AccountsTest do
  use Caju.DataCase, async: true

  import Caju.Factories.AccountFactory

  alias Caju.CardTransactions.Accounts

  describe "get_and_lock/1" do
    test "should return the account when account_id is valid" do
      %{id: account_id} = account = insert(:account)

      assert {:ok, ^account} = Accounts.get_and_lock(account_id)
    end

    test "should return error when account is not found" do
      non_existent_id = Ecto.UUID.generate()

      assert {:error, :account_not_found} == Accounts.get_and_lock(non_existent_id)
    end
  end

  describe "update/2" do
    test "should update account when params are valid" do
      account = insert(:account, food_balance: 100)

      attrs = %{food_balance: 200}
      expected_updated_account = Map.put(account, :food_balance, 200)

      assert {:ok, ^expected_updated_account} = Accounts.update(account, attrs)
    end
  end
end
