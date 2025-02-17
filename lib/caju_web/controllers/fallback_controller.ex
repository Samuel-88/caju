defmodule CajuWeb.FallbackController do
  use CajuWeb, :controller

  require Logger

  @error_response_code "07"

  def call(conn, error) do
    Logger.error("Error authorizing card transaction: `#{inspect(error)}`")

    json(conn, %{code: @error_response_code})
  end
end
