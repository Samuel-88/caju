defmodule Caju.CardTransactions.Accounts do
  import Ecto.Query

  alias Caju.CardTransactions.Accounts.Account
  alias Caju.Repo

  @spec get_and_lock(account_id :: Ecto.UUID.t()) ::
          {:ok, account :: %Account{}} | {:error, :account_not_found}
  def get_and_lock(account_id) do
    account =
      Account
      |> where([account], account.id == ^account_id)
      |> lock("FOR UPDATE")
      |> Repo.one()

    case account do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  @spec update(account :: %Account{}, attrs :: map()) ::
          {:ok, %Account{}} | {:error, Ecto.Changeset.t()}
  def update(account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end
end
