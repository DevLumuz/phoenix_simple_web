.PHONY: setup deps server test db.create db.migrate db.reset db.seed

setup:
	mix deps.get
	mix ecto.setup

deps:
	mix deps.get

server:
	mix phx.server

test:
	mix test

db.create:
	mix ecto.create

db.migrate:
	mix ecto.migrate

db.reset:
	mix ecto.reset

db.seed:
	mix run priv/repo/seeds.exs
