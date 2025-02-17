defmodule Caju.CardTransactions do
  require Logger

  alias Caju.CardTransactions.{Accounts, Transactions}
  alias Caju.CardTransactions.Accounts.Account
  alias Caju.CardTransactions.Transactions.Transaction
  alias Caju.Repo

  @approved_response_code "00"
  @declined_response_code "51"
  @error_response_code "07"
  @food_mccs ~w(5411 5412)
  @meal_mccs ~w(5811 5812)

  @spec authorize(payload :: map()) :: response_code :: String.t()
  def authorize(
        %{
          "id" => _transaction_id,
          "account_id" => account_id,
          "amount" => amount,
          "merchant" => _merchant,
          "mcc" => _mcc
        } = payload
      ) do
    Repo.transaction(fn ->
      with {:ok, %Account{} = account} <- Accounts.get_and_lock(account_id),
           {:ok, %Transaction{} = transaction} <- Transactions.create(payload) do
        debit_balance(account, amount, transaction.mcc)
      end
    end)
    |> handle_authorize_transaction_result()
  end

  def authorize(invalid_payload) do
    Logger.error("Invalid card authorization payload: `#{inspect(invalid_payload)}`")

    @error_response_code
  end

  defp debit_balance(%Account{} = account, amount, mcc) when mcc in @food_mccs do
    cond do
      account.food_balance >= amount -> debit_food_balance(account, amount)
      account.cash_balance >= amount -> debit_cash_balance(account, amount)
      true -> {:error, :no_available_balance}
    end
  end

  defp debit_balance(%Account{} = account, amount, mcc) when mcc in @meal_mccs do
    cond do
      account.meal_balance >= amount -> debit_meal_balance(account, amount)
      account.cash_balance >= amount -> debit_cash_balance(account, amount)
      true -> {:error, :no_available_balance}
    end
  end

  defp debit_balance(account, amount, _mcc) do
    if account.cash_balance >= amount do
      debit_cash_balance(account, amount)
    else
      {:error, :no_available_balance}
    end
  end

  defp handle_authorize_transaction_result({:ok, {:ok, %Account{}}}),
    do: @approved_response_code

  defp handle_authorize_transaction_result({:ok, {:error, :no_available_balance}}),
    do: @declined_response_code

  defp handle_authorize_transaction_result(error) do
    Logger.error("Failed to authorize transaction due to: `#{inspect(error)}`")

    @error_response_code
  end

  defp debit_food_balance(account, amount) do
    updated_food_balance = account.food_balance - amount

    Accounts.update(account, %{food_balance: updated_food_balance})
  end

  defp debit_meal_balance(account, amount) do
    updated_meal_balance = account.meal_balance - amount

    Accounts.update(account, %{meal_balance: updated_meal_balance})
  end

  defp debit_cash_balance(account, amount) do
    updated_cash_balance = account.cash_balance - amount

    Accounts.update(account, %{cash_balance: updated_cash_balance})
  end
end
