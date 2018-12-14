down:
	docker-compose down

deps.get:
	docker-compose exec phoenix mix deps.get

ecto.setup:
	docker-compose exec phoenix mix ecto.setup

build:
	make deps.get
	docker-compose exec phoenix mix deps.compile
	make ecto.setup
	docker-compose exec phoenix mix compile

server:
	docker-compose exec phoenix mix phx.server
