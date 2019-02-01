# Extend from the official Elixir image
FROM elixir:1.8.1-alpine

RUN apk update && \
    apk add -y postgresql-client

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force
# RUN chmod 777 /app/entrypoint.sh
RUN chmod +x entrypoint.sh

RUN mix deps.get --force

# Compile the project
RUN mix local.rebar --force
RUN mix do compile --force

RUN ls -a

ENTRYPOINT ["./entrypoint.sh"]
