.PHONY: show-help build start stop down nuke inspect-database

.DEFAULT_GOAL := show-help

show-help:
	@echo 'Available Commands:'
	@echo '  build | Build all containers.'
	@echo '  start | Starts all containers.'
	@echo '  stop | Stops all running containers.'
	@echo '  down | Stops containers, clears volumes & networks. If things are not working as expected, you likely want to run this command.'
	@echo '  nuke | Clears all images, containers, networks, and volumes. If all else fails, run this command.'
	@echo '  inspect-database | Runs psql in the dev database of the service.'

build:
	docker compose --file docker-compose.yaml build --parallel

start:
	- (smee --url ${SMEE_CHANNEL_URL} --path /github_event_handler --port 3000 > /dev/null 2>&1)&
	- docker compose --file docker-compose.yaml up --renew-anon-volumes

stop:
	docker stop `docker ps -aq`

down:
	docker compose --file docker-compose.yaml down -v

nuke:
	- docker stop `docker ps -aq`
	- @echo 'Note: this may take a while'
	- docker system prune --all --volumes

inspect-database:
	docker compose --file docker-compose.yaml exec database psql database user
