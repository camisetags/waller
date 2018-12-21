defmodule WallerWeb.UserController do
  use WallerWeb, :controller

  alias Waller.User.UserRepo
  alias Waller.User.User

  action_fallback WallerWeb.FallbackController

  def index(conn, _params) do
    user = UserRepo.list_user()
    render(conn, "index.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    case UserRepo.create_user(user_params) do
      {:ok, %User{} = user} -> 
        conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show.json", user: user)
      
      {:error, errors} -> conn |> json(%{errors: errors})
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserRepo.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserRepo.get_user!(id)

    with {:ok, %User{} = user} <- UserRepo.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserRepo.get_user!(id)

    with {:ok, %User{}} <- UserRepo.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
