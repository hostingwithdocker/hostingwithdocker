# Hosting w/ Docker

Migration from classic application-deployment to most-recent hosting techniques using Docker container
a.k.a. application hosting with Docker
a.k.a. hosting with docker 
a.k.a. hwd
## Pre-requirement
You host must be already bellow tools:
- Docker ^18.06.1-ce
- Docker Compose ^1.23.2
- openssl (optional for self signed)

## REQUIREMENTS FOR DEMO:
- Simple to start up the Wordpress webpage
- Less command, code

## START
- Clone `.env` from file `.env-example`
- Config the right value in `.env`
- run the script `./install.sh http`

> These scripts in this repo forked from [mjstealey](https://github.com/mjstealey/wordpress-nginx-docker).