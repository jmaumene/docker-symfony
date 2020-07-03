# Docker for symfony

By Julien Maumené :  http://www.maumene.fr

Docker with:
 - PHP 7.4
 - PostgreSQL 9.4
 - Phppgadmin
 - maildev (mail catcher)
 - preconfigured for Traefik 2 (https://github.com/jmaumene/traefik-docker-proxy)
 
## Requirement

### Docker
See : https://docs.docker.com/install/

### Docker-compose
See : https://docs.docker.com/compose/install/

### Make
```shell script
$ sudo apt-get install make
```
### Traefik (optional)
See : https://github.com/jmaumene/traefik-docker-proxy

if you don't want to use my traefik docker, you have to create network (or remove it in docker-compose):
```shell script
docker network create traefik_webgateway
```

## Installation

Clone this repository in your project :
```shell script
$ git clone https://github.com/jmaumene/docker-symfony.git docker
$ tree
your-project-directory
├── docker
└── public (created on setup)
    └── index.php

```

## Configuration : 

Run "make setup" and folow instruction
```shell script
$ make setup
```

Copy dev parameters on your project
```shell script
$ make install-config-dev
```

Run "make up" to run the docker, make stop or make restart
```shell script
$ make up
$ make stop
$ make restart
```

To check the symfony requirements :
```shell script
$ make sf-check
```

## Use

To run a command in the docker , "make exec" :
```shell script
$ make exec ls
```

To enter in the docker :
```shell script
$ make exec bash
```

### Symfony

To check the symfony requirements :
```shell script
$ make sf-check
```

Create Project:
```shell script
$ make exec "git config --global user.email 'julien@maumené.fr'"
$ make exec "git config --global user.name 'Julien Maumené'"
$ make exec "symfony new --full my_project_name"
```

Move all files (including hidden files like .git directory) from your-project-directory/name-of-project-in-symfony/* to your-project-directory

Go to www.project-url.local
