# Hosting w/ Docker
Migration from classic application-deployment to most-recent hosting techniques using Docker container
a.k.a. application hosting with Docker
a.k.a. hosting with docker 
a.k.a. hwd

## Pre-requirement
You host must be already bellow tools:
- docker ^18.06.1-ce
- docker-compose ^1.23.2
- openssl (optional for self signed)

## REQUIREMENTS FOR DEMO:
- a simple startup to run a Wordpress-based website
- run ONE script to create
- can have 02 wordpress instances on ONE host/machine

## START
- clone `.env` from file `.env-example`
- config the right value in `.env`
- run the script 
```bash
./install.sh http localhost
```
> script files in this repo forked from [mjstealey](https://github.com/mjstealey/wordpress-nginx-docker).


## STOP
- run `stop-and-remove.sh` #TODO double check that this command only stopped the containers listed in docker-compose.yml