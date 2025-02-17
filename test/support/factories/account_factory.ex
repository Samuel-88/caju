defmodule Caju.Factories.AccountFactory do
  use ExMachina.Ecto, repo: Caju.Repo

  alias Caju.CardTransactions.Accounts.Account

  def account_factory do
    %Account{
      food_balance: 100,
      meal_balance: 200,
      cash_balance: 300
    }
  end
end
