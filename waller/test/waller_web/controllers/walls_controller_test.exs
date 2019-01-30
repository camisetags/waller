defmodule WallerWeb.WallsControllerTest do
  use WallerWeb.ConnCase

  alias Waller.User.UserRepo
  alias Waller.Wall.WallRepo

  @user_attrs1 %{
    name: "Marcos",
    photo: "https://i.imgur.com/1BhT3HG.png",
    age: 27
  }

  @user_attrs2 %{
    name: "Maria",
    photo: "https://i.imgur.com/gM42bbe.png",
    age: 29
  }

  @user_attrs3 %{
    name: "Gabriel",
    photo:
      "https://scontent.fsdu12-1.fna.fbcdn.net/v/t1.0-9/11391364_883830578356717_6741916066961457230_n.jpg?_nc_cat=109&_nc_ht=scontent.fsdu12-1.fna&oh=ad19bc6a37d4b7e1c67ac3d98b7b06a9&oe=5CBBF0B8",
    age: 26
  }

  @user_attrs4 %{
    name: "Luiza",
    photo:
      "https://scontent.fsdu12-1.fna.fbcdn.net/v/t1.0-9/22406395_10210254327854262_487461581532560924_n.jpg?_nc_cat=100&_nc_ht=scontent.fsdu12-1.fna&oh=1f804ad45afe58d6bff38b663595e5fb&oe=5CB6E4F5",
    age: 26
  }

  @walls_attr1 %{
    running: true,
    result_date: DateTime.from_naive!(~N[2019-10-15 10:00:00], "Etc/UTC")
  }

  @walls_attr2 %{
    running: true,
    result_date: DateTime.from_naive!(~N[2019-11-15 10:00:00], "Etc/UTC")
  }

  @walls_attr3 %{
    running: true,
    result_date: DateTime.from_naive!(~N[2019-12-15 10:00:00], "Etc/UTC")
  }

  def fixture(param) do
    generate_walls(param)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:generate_walls]

    test "list all walls paginated", %{conn: conn} do
      conn = get(conn, Routes.walls_path(conn, :index))
      response_entries = json_response(conn, 200)["data"]["entries"]

      assert length(response_entries) == 3
    end

    test "list only doubles walls", %{conn: conn} do
      conn = get(conn, Routes.walls_path(conn, :index, only_doubles: true))
      response_entries = json_response(conn, 200)["data"]["entries"]

      assert length(response_entries) == 2
    end
  end

  describe "create" do
    setup [:generate_users]

    test "create wall with 2 users", %{conn: conn} do
      [_ | user_ids] =
        UserRepo.first_three()
        |> Enum.map(fn user ->
          user.id
        end)

      conn =
        post(
          conn,
          Routes.walls_path(conn, :create,
            result_date: "2019-10-23T23:50:07Z",
            user_ids: user_ids
          )
        )

      response = json_response(conn, 201)

      assert response["data"]["running"] == true
      assert length(response["data"]["users"]) == 2
    end

    test "create wall with 3 users", %{conn: conn} do
      user_ids =
        UserRepo.first_three()
        |> Enum.map(fn user ->
          user.id
        end)

      conn =
        post(
          conn,
          Routes.walls_path(conn, :create,
            result_date: "2019-10-23T23:50:07Z",
            user_ids: user_ids
          )
        )

      response = json_response(conn, 201)

      assert response["data"]["running"] == true
      assert length(response["data"]["users"]) == 3
    end
  end

  describe "vote" do
    setup [:generate_walls]

    test "send vote to user", %{conn: conn} do
      page = WallRepo.list(page: 1, page_size: 1)
      wall = Enum.at(page.entries, 0)
      user = Enum.at(wall.users, 0)

      conn = post(conn, Routes.walls_path(conn, :vote, wall.id, user.id))

      response = json_response(conn, 200)

      assert response["message"] == "Your vote was computed!"
    end

    test "error if user or wall does not exists", %{conn: conn} do
      conn = post(conn, Routes.walls_path(conn, :vote, 2_344_345, 1_029_380))
      response = json_response(conn, 422)

      assert response["errors"] == ["Wall or user does not exists."]
    end
  end

  defp generate_users(_) do
    user1 = UserRepo.create_user(@user_attrs1)
    user2 = UserRepo.create_user(@user_attrs2)
    user3 = UserRepo.create_user(@user_attrs3)
    user4 = UserRepo.create_user(@user_attrs4)

    {:ok, users: [user1, user2, user3, user4]}
  end

  defp generate_walls(_) do
    user1 = UserRepo.create_user(@user_attrs1)
    user2 = UserRepo.create_user(@user_attrs2)
    user3 = UserRepo.create_user(@user_attrs3)
    user4 = UserRepo.create_user(@user_attrs4)

    wall1 = WallRepo.form_wall(@walls_attr1, [elem(user1, 1), elem(user2, 1)])
    wall2 = WallRepo.form_wall(@walls_attr2, [elem(user3, 1), elem(user4, 1)])
    wall3 = WallRepo.form_wall(@walls_attr3, [elem(user3, 1), elem(user4, 1), elem(user2, 1)])

    {:ok, walls: [wall1, wall2, wall3]}
  end
end
