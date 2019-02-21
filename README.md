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
- a simple Wordpress web page
- Less command, code

## START
- clone `.env` from file `.env-example`
- config the right value in `.env`
- run the script `./install.sh http`
> script files in this repo forked from [mjstealey](https://github.com/mjstealey/wordpress-nginx-docker).


## STOP
- run `stop-and-remove.sh`

#TODO rename container name with prefix hwd_xxx