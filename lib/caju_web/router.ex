defmodule CajuWeb.Router do
  use CajuWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CajuWeb do
    pipe_through :api

    post "/card_transactions", CardTransactionsController, :authorize_transaction
  end
end
