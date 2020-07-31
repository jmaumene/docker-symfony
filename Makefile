# ###############################
# DOCKER MAKEFILE               #
# By jmaumene                   #
# ###############################
#
# Do not edit parameters, you can change value in .env after setup
#

# default App parameters
SERVICE_WEB_NAME=web
CONFIG_SOURCE=config/parameters.yml
CONFIG_DEST=../app/config/

#Default .env content
COMPOSE_PROJECT_NAME=docker-project
DB_USER=root
DB_PASSWORD=root
DB_NAME=project
HOST_NAME=project.local

-include .env
export

#Symfony parameters
CONSOLE=php app/console

DC=docker-compose -p $(COMPOSE_PROJECT_NAME)
EXEC=$(DC) exec --user www-data $(SERVICE_WEB_NAME)

## —— Installation ———————————————————————————————————————————————————————————
#*
#* Run make setup, make install-config-dev and make up


## —— Help ———————————————————————————————————————————————————————————————————
.DEFAULT_GOAL := help

help: ## Outputs this help screen
	@sed -e 's/Makefile//' $(MAKEFILE_LIST) | grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)|(^#\*)' | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m#\*/[31m/' | sed -e 's/\[32m##/\n\r[33m/'

## —— Docker —————————————————————————————————————————————————————————————————
setup: ## Setup docker
	@echo
	@echo "\033[031m —— Create .env file ———————————————————————————————————————————————————————\033[0m"
	@echo
	@echo Leave empty for default value
	@echo

	# COMPOSE_PROJECT_NAME
	@read -p "Enter docker project name [$(COMPOSE_PROJECT_NAME)] : " INPUT ;\
	COMPOSE_PROJECT_NAME=$${INPUT:-$$COMPOSE_PROJECT_NAME} ;\
	read -p "Enter database username [$(DB_USER)] : " INPUT ;\
	DB_USER=$${INPUT:-$$DB_USER} ;\
	read -p "Enter database password [$(DB_PASSWORD)] : " INPUT ;\
	DB_PASSWORD=$${INPUT:-$$DB_PASSWORD} ;\
	read -p "Enter database name [$(DB_NAME)] : " INPUT ;\
	DB_NAME=$${INPUT:-$$DB_NAME} ;\
	read -p "Enter local url [$(HOST_NAME)] : " INPUT ;\
	HOST_NAME=$${INPUT:-$$HOST_NAME} ;\
	echo ;\
	echo COMPOSE_PROJECT_NAME=$$COMPOSE_PROJECT_NAME > .env ;\
	echo DB_USER=$$DB_USER >> .env ;\
	echo DB_PASSWORD=$$DB_PASSWORD >> .env ;\
	echo DB_NAME=$$DB_NAME >> .env ;\
	echo HOST_NAME=$$HOST_NAME >> .env; \
	echo HOST_ADDR=$$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') >> .env; \
	echo USER_ID=$$(id -u) >> .env; \
	echo GROUP_ID=$$(id -g) >> .env; \
	echo Add this line in your /etc/hosts file : ;\
	echo ; \
	echo "127.0.0.1	$$HOST_NAME www.$$HOST_NAME db.$$HOST_NAME pma.$$HOST_NAME mail.$$HOST_NAME" ;\
	echo ;

up: ## Start containers
	$(DC) up -d

stop: ## Stop containers
	$(DC) stop

restart: stop up ## Restart containers

exec: ## Execute command in container : make exec bash
	$(EXEC) $(filter-out $@,$(MAKECMDGOALS))

docker-info: ## Display docker config .env
	@cat .env

## —— Application ————————————————————————————————————————————————————————————
install-config-dev: ## Instal config if not exist
ifeq ("$(wildcard $(CONFIG_DEST))","")
	cp -r $(CONFIG_SOURCE) $(CONFIG_DEST)
else
	@echo "\033[031m File $(CONFIG_DEST) already exist, remove first"
endif

## —— Symfony ————————————————————————————————————————————————————————————————
console: ## Execute commande in symfony : make console doctrine:schema:update
	$(EXEC) $(CONSOLE) $(filter-out $@,$(MAKECMDGOALS))

# used with symfony console
%: # thanks to chakrit
	@: # thanks to William Pursell

sf-check: ## Symfony check requirements
	$(EXEC) symfony check:requirements
