#!/bin/bash

manual='\
MANUAL
  This script needs 3 arguments
  $1 http|https  a.k.a. the type of web server
  $2 domain name e.g.   www.example.com, localhost
  $3 selfsigned         set this to self-signed the host

  E.g.
  ./start.sh http
  ./start.sh http localhost
'

# load params
  http_type=$1
     domain=$2
 selfsigned=$3

if [[ -z $http_type ]]; then http_type='http'; fi

# prepare data folders
mkdir -p certs/ certs-data/ \
         nginx/ logs/nginx/ \
         mysql/ \
         wordpress/

# .env loading
if [[ ! -f .env ]]; then
  echo "[x] Missing the env file. Please copy the .env_example -> .env and edit these appropriate value."
  exit $?
fi


# nginx config loading
if [[ ! -f nginx/default.conf ]]; then
  echo ">>> Copy the nginx config file"
  cp  "nginx_conf_source/default_$http_type.conf.template"  nginx/default.conf
fi


# selfsigned loading
if [[ "$selfsigned" = "selfsigned" ]]; then
  cd ./letsenscrypt
    ./self-signed-init.sh $domain
    sed -i 's/FQDN_OR_IP/localhost/gi' ../nginx/default.conf # FQDN_OR_IP aka full-qualified domain-name or ip
    sed -i 's/ssl_trusted_certificate/#ssl_trusted_certificate/gi' ../nginx/default.conf
  cd --
fi


# start the app aka the docker stack
echo ">>> Run the stack: Mysql / Wordpress / Nginx"
docker-compose up -d
