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
  **caution** that you should set nginx port values to be greater than 1000 
  TODO verify this value threshold
  e.g. nginx http  port 9000
  e.g. nginx https port 44390
  
- run the script 

  (This step starts a WordPress site from scratch. Looking for migration? Take the next session bellow.)
  
  sample call as below - note CODE means this project 's git-cloned folder
  ```bash
  : you@localhost:CODE $
  ./start.sh http localhost
  
  : you@localhost:CODE $
  ./stop-and-remove.sh 1 && ./start.sh http localhost
  
  : you@localhost:CODE $
  ./restart-http-local.sh
  ```

- it may need some time to finish loading every thing - until then we may get 502 Bad Getway error

## MIGRATION
- copy your wordpress datadump file into `initdb`
- copy your old `wp-content` into this current working dir `./wp-content`
- make sure you added this line `- ./wp-content:/var/www/html/wp-content` to docker-compose.yml

  ```yaml
  wordpress: # create service wordpress:9000 in the :network
    image: wordpress:${WORDPRESS_VERSION:-latest}
    container_name: ${STACK_PREFIX:-HWD}wordpress
    volumes:
      - ./wordpress:/var/www/html
      - ./wp-content:/var/www/html/wp-content
  ```

- run the script:

  ```bash
  : you@localhost:CODE $
  LOAD_DATADUMP_FILE=./initdb/your-data-file.sql ./start.sh http localhost
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
