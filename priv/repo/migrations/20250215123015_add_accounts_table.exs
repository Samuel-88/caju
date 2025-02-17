defmodule Caju.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table("accounts", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :food_balance, :bigint, null: false, default: 0
      add :meal_balance, :bigint, null: false, default: 0
      add :cash_balance, :bigint, null: false, default: 0

      timestamps()
    end
  end
end
