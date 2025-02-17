defmodule CajuWeb.CardTransactionsControllerTest do
  use CajuWeb.ConnCase, async: true

  import Caju.Factories.AccountFactory

  @successful_response_code "00"
  @insufficient_funds_response_code "51"
  @error_response_code "07"
  @http_ok_status 200

  setup do
    account = insert(:account, food_balance: 100, meal_balance: 200, cash_balance: 300)

    {:ok, account: account}
  end

  describe "authorize_transaction/2" do
    test "returns a successful response code when authorization is successful", %{
      account: account,
      conn: conn
    } do
      params = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account.id,
        "amount" => 150,
        "merchant" => "FOOD MERCHANT",
        "mcc" => "5411"
      }

      conn = post(conn, ~p"/api/card_transactions", params)
      assert json_response(conn, @http_ok_status) == %{"code" => @successful_response_code}
    end

    test "should return insufficient funds error when balance is not available", %{
      account: account,
      conn: conn
    } do
      params = %{
        "id" => Ecto.UUID.generate(),
        "account_id" => account.id,
        "amount" => 999,
        "merchant" => "FOOD MERCHANT",
        "mcc" => "5411"
      }

      conn = post(conn, ~p"/api/card_transactions", params)

      assert json_response(conn, @http_ok_status) == %{
               "code" => @insufficient_funds_response_code
             }
    end

    test "returns an error response code when authorization fails", %{conn: conn} do
      invalid_params = %{"invalid" => "invalid"}

      conn = post(conn, ~p"/api/card_transactions", invalid_params)
      assert json_response(conn, @http_ok_status) == %{"code" => @error_response_code}
    end
  end
end
