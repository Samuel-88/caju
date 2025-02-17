defmodule Caju.CardTransactions.Transactions do
  alias Caju.CardTransactions.Transactions.Transaction
  alias Caju.Repo

  @spec create(params :: map()) ::
          {:ok, transaction :: %Transaction{}} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end
end
