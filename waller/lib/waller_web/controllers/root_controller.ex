defmodule WallerWeb.RootController do
  use WallerWeb, :controller
  alias Poison
  import HTTPoison, only: [post: 3]

  def index(conn, _params) do
    conn |> json(%{message: "Welcome!"})
  end

  def verify_captcha(conn, %{ "response" => response }) do
    captcha_url = "https://www.google.com/recaptcha/api/siteverify"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    secret = "6Ldlm4UUAAAAAMwECDVBzSuncDBEw5A6EubInKyT"
    gtoken_body = "secret=#{secret}&response=#{response}"

    case post(captcha_url, gtoken_body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        conn |> json(%{ data: Poison.decode!(body) })
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        conn 
        |> put_status(:not_found)
        |> json(%{ error: "Not found" })
      {:error, %HTTPoison.Error{reason: reason}} ->
        conn 
        |> put_status(:internal_server_error)
        |> json(%{ error: "Internal server error" })
    end
  end
end
