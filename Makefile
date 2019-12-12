################################
# DOCKER MAKEFILE              #
# By jmaumene                  #
################################
#
# Do not edit parameters, you can change value in .env after setup
#

# default App parameters
SERVICE_WEB_NAME=web
CONFIG_SOURCE=config/parameters.yml
CONFIG_DEST=../app/config/parameters.yml

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

# ===================================
# Docker
# ===================================
up:
	$(DC) up -d

stop:
	$(DC) stop

restart: stop up

exec:
	$(EXEC) $(filter-out $@,$(MAKECMDGOALS))

# setup installation ( create .env file)
setup:
	@echo -=- Create .env -=-
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
	read -p "Enter database username [$(DB_NAME)] : " INPUT ;\
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

	@echo Add this line in your /etc/hosts file : ;\
	echo ; \
	echo "127.0.0.1	$$HOST_NAME www.$$HOST_NAME db.$$HOST_NAME pma.$$HOST_NAME mail.$$HOST_NAME" ;\
	echo ;

docker-info:
	@cat .env

# ===================================
# APP
# ===================================
install-config-dev:
ifeq ("$(wildcard $(CONFIG_DEST))","")
	cp $(CONFIG_SOURCE) $(CONFIG_DEST)
else
	@echo "File $(CONFIG_DEST) already exist, remove first"
endif

# ===================================
# SYMFONY
# ===================================

# symfony console use with arguments
console:
	$(EXEC) $(CONSOLE) $(filter-out $@,$(MAKECMDGOALS))

# used with symfony console
%: # thanks to chakrit
	@: # thanks to William Pursell

# Symfony check requirements
sf-check:
	$(EXEC) symfony check:requirements
