defmodule WallerWeb.Roots.RootControllerTest do
  use WallerWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "Application index", %{conn: conn} do
      conn = get(conn, Routes.root_path(conn, :index))
      assert json_response(conn, 200) == %{"message" => "Welcome!"}
    end
  end
end
