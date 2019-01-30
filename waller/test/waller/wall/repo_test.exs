defmodule Waller.WallRepoTest do
  use Waller.DataCase

  alias Waller.Wall.WallRepo

  describe "wall" do
    alias Waller.Wall.Wall

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

    @walls_attr1 %{
      running: true,
      result_date: DateTime.from_naive!(~N[2019-10-15 10:00:00], "Etc/UTC")
    }

    def wall_fixture() do
      {:ok, wall} = WallRepo.form_wall(@walls_attr1, [@user_attrs1, @user_attrs2])

      wall
    end

    def wall_fixture_triple() do
      {:ok, wall} = WallRepo.form_wall(@walls_attr1, [@user_attrs1, @user_attrs2, @user_attrs1])

      wall
    end

    test "get_wall!/0 get one wall" do
      wall_fix = wall_fixture()
      wall = WallRepo.get_wall!(wall_fix.id)

      assert wall.id == wall_fix.id
    end

    test "form_wall/2" do
      assert {:ok, %Wall{} = wall} =
               WallRepo.form_wall(@walls_attr1, [@user_attrs1, @user_attrs2])

      assert wall.running == true
      assert Enum.at(wall.users, 0).name == @user_attrs1.name
      assert Enum.at(wall.users, 1).name == @user_attrs2.name
    end

    test "list/1" do
      wall_fix = wall_fixture()
      result = WallRepo.list(page: 1, page_size: 1)

      assert Enum.at(result.entries, 0).id == wall_fix.id
    end

    test "list_doubles/1" do
      wall_fixture_triple()
      result = WallRepo.list_doubles(page: 1, page_size: 1)

      assert length(result.entries) == 0
    end
  end
end
