defmodule Caju.CardTransactions.Transactions.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  alias Caju.CardTransactions.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields [:id, :amount, :merchant, :mcc, :account_id]

  @food_mcc "5411"
  @meal_mcc "5811"
  @food_merchants ~w(food supermercado mercado)
  @meal_merchants ~w(meal restaurant cafe eat)

  schema "transactions" do
    field :amount, :integer
    field :merchant, :string
    field :mcc, :string

    belongs_to :account, Account

    timestamps()
  end

  @spec changeset(transaction :: %__MODULE__{}, attrs :: map()) :: Ecto.Changeset.t()
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:account)
    |> override_mcc()
  end

  defp override_mcc(%{valid?: false} = changeset), do: changeset

  defp override_mcc(changeset) do
    merchant = changeset |> get_field(:merchant) |> String.downcase()
    original_mcc = get_field(changeset, :mcc)

    overrided_mcc =
      cond do
        String.contains?(merchant, @food_merchants) -> @food_mcc
        String.contains?(merchant, @meal_merchants) -> @meal_mcc
        true -> original_mcc
      end

    put_change(changeset, :mcc, overrided_mcc)
  end
end
