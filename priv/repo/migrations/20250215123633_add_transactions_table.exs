defmodule Caju.Repo.Migrations.AddTransactionsTable do
  use Ecto.Migration

  def change do
    create table("transactions", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer, null: false
      add :merchant, :string, null: false
      add :mcc, :string, null: false
      add :account_id, references(:accounts, column: :id, type: :binary_id), null: false

      timestamps()
    end
  end
end
