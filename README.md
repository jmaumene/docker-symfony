# Docker for symfony

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
$ sudo apt install make
```


## Installation

Clone this repository in your project :
```shell script
$ git clone https://github.com/jmaumene/docker-symfony.git docker
$ tree
your-project-directory
├── docker
└── public
    └── index.php

```

## Configuration : 

Run "make setup" and folow instruction
```shell script
$ make setup
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
To check the symfony requirements :
```shell script
$ make exec new --full new-project 
```
