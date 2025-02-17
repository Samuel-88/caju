defmodule CajuWeb.CardTransactionsController do
  use CajuWeb, :controller

  alias Caju.CardTransactions

  action_fallback CajuWeb.FallbackController

  def authorize_transaction(conn, params) do
    with response_code <- CardTransactions.authorize(params) do
      json(conn, %{code: response_code})
    end
  end
end
