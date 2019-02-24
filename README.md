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
- a simple get-started demo to run a Wordpress-based website
- run ONE script to create
- can have TWO wordpress instances on ONE host/machine on the cloud e.g. Vultr cloud

## START
- clone `.env` from file `.env-example`
- config the right value in `.env`
- run the script 
  sample call as below - note CODE means this project 's git-cloned folder
  ```bash
  : you@localhost:CODE $
  ./start.sh http localhost
  
  : you@localhost:CODE $
  ./stop-and-remove.sh 1 && ./start.sh http localhost
  
  : you@localhost:CODE $
  ./restart-http-local.sh
  ```


## STOP
- stop only 
  ```bash
  ./stop.sh
  ```

- stop and remove everything
  ```bash
  stop-and-remove.sh
  stop-and-remove.sh y # for auto-answer yes
  ```


## TEST
```bash
./aftermath-test.sh
```


## reference
script files in this repo forked from [mjstealey](https://github.com/mjstealey/wordpress-nginx-docker).
