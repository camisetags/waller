down:
	docker-compose down

deps.get:
	docker-compose exec phoenix mix deps.get

ecto.setup:
	docker-compose exec phoenix mix ecto.setup

build:
	make deps.get
	mix deps.compile
	make ecto.setup
	mix compile

server:
	docker-compose exec phoenix mix phx.server
