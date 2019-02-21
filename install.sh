#!/bin/bash
http_type=$1
domain=$2
what_signed=$3

mkdir -p certs/ certs-data/ nginx/ logs/nginx/ mysql/ wordpress/

if [ "$http_type" = "" ] 
then
  echo "
  [x] Missing arguments: <http|https> what type do you use?
  Example: ./install.sh http"
  exit $?
fi

if [ ! -f nginx/default.conf ]
then
  echo ">>> Copy the nginx config file"
  cp nginx_conf_source/default_$http_type.conf.template nginx/default.conf
fi

if [ ! -f .env ]
then
  echo "[x] Missing the env file. Please copy the .env_example -> .env and edit these appropriate value."
  exit $?
fi

if [ "$what_signed" = "selfsigned" ]
then
  cd ./letsenscrypt
  ./self-signed-init.sh $domain
fi

echo ">>> Run the stack: Mysql / Wordpress / Nginx"
docker-compose up -d