defmodule Caju.CardTransactions.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias Caju.CardTransactions.Transactions.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_fields [:food_balance, :meal_balance, :cash_balance]

  schema "accounts" do
    field :food_balance, :integer, default: 0
    field :meal_balance, :integer, default: 0
    field :cash_balance, :integer, default: 0

    has_many :transactions, Transaction

    timestamps()
  end

  @spec changeset(account :: %__MODULE__{}, attrs :: map()) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, @required_fields)
    |> validate_number(:food_balance, greater_than_or_equal_to: 0)
    |> validate_number(:meal_balance, greater_than_or_equal_to: 0)
    |> validate_number(:cash_balance, greater_than_or_equal_to: 0)
  end
end
