down:
	docker-compose down

deps.get:
	docker-compose exec phoenix mix deps.get

ecto.setup:
	docker-compose exec phoenix mix ecto.setup

build:
	make deps.get
	make ecto.setup

server:
	docker-compose exec phoenix mix phx.server
