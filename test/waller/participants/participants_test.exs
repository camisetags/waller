defmodule Waller.ParticipantsTest do
  use Waller.DataCase

  alias Waller.Participants

  describe "user" do
    alias Waller.Participants.User

    @valid_attrs %{age: 42, name: "some name"}
    @update_attrs %{age: 43, name: "some updated name"}
    @invalid_attrs %{age: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Participants.create_user()

      user
    end

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert Participants.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Participants.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Participants.create_user(@valid_attrs)
      assert user.age == 42
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Participants.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Participants.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Participants.update_user(user, @invalid_attrs)
      assert user == Participants.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Participants.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Participants.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Participants.change_user(user)
    end
  end
end
