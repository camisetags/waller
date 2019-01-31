# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Waller.Repo.insert!(%Waller.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Waller.Wall.WallRepo
alias Waller.User.UserRepo

user1 =
  UserRepo.create_user(%{
    name: "Marcos",
    photo: "https://i.imgur.com/1BhT3HG.png",
    age: 27
  })

user2 =
  UserRepo.create_user(%{
    name: "Maria",
    photo: "https://i.imgur.com/gM42bbe.png",
    age: 29
  })

user3 =
  UserRepo.create_user(%{
    name: "Gabriel",
    photo:
      "https://scontent.fsdu12-1.fna.fbcdn.net/v/t1.0-9/11391364_883830578356717_6741916066961457230_n.jpg?_nc_cat=109&_nc_ht=scontent.fsdu12-1.fna&oh=ad19bc6a37d4b7e1c67ac3d98b7b06a9&oe=5CBBF0B8",
    age: 26
  })

user4 =
  UserRepo.create_user(%{
    name: "Luiza",
    photo:
      "https://scontent.fsdu12-1.fna.fbcdn.net/v/t1.0-9/22406395_10210254327854262_487461581532560924_n.jpg?_nc_cat=100&_nc_ht=scontent.fsdu12-1.fna&oh=1f804ad45afe58d6bff38b663595e5fb&oe=5CB6E4F5",
    age: 26
  })

wall = %{
  running: true,
  result_date: DateTime.from_naive!(~N[2019-10-15 10:00:00], "Etc/UTC")
}

WallRepo.form_wall(wall, [elem(user1, 1), elem(user2, 1)])

wall = %{
  running: true,
  result_date: DateTime.from_naive!(~N[2019-11-15 10:00:00], "Etc/UTC")
}

WallRepo.form_wall(wall, [elem(user3, 1), elem(user4, 1)])

wall = %{
  running: true,
  result_date: DateTime.from_naive!(~N[2019-12-15 10:00:00], "Etc/UTC")
}

WallRepo.form_wall(wall, [elem(user3, 1), elem(user4, 1), elem(user2, 1)])
