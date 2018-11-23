defmodule WallerWeb.Roots.RootControllerTest do
  use WallerWeb.ConnCase

  alias Waller.Roots
  alias Waller.Roots.Root

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:root) do
    {:ok, root} = Roots.create_root(@create_attrs)
    root
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all roots", %{conn: conn} do
      conn = get(conn, Routes.roots_root_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create root" do
    test "renders root when data is valid", %{conn: conn} do
      conn = post(conn, Routes.roots_root_path(conn, :create), root: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.roots_root_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.roots_root_path(conn, :create), root: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update root" do
    setup [:create_root]

    test "renders root when data is valid", %{conn: conn, root: %Root{id: id} = root} do
      conn = put(conn, Routes.roots_root_path(conn, :update, root), root: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.roots_root_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, root: root} do
      conn = put(conn, Routes.roots_root_path(conn, :update, root), root: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete root" do
    setup [:create_root]

    test "deletes chosen root", %{conn: conn, root: root} do
      conn = delete(conn, Routes.roots_root_path(conn, :delete, root))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.roots_root_path(conn, :show, root))
      end
    end
  end

  defp create_root(_) do
    root = fixture(:root)
    {:ok, root: root}
  end
end
