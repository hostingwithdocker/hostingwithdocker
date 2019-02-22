#!/bin/bash
http_type=$1
domain=$2
what_signed=$3

if [ "$http_type" = "" ] 
then
  echo "MANUAL: 
  This script needs 3 arguments:
  1) http|https : the type of web server 
  2) 'www.example.com' or 'localhost' : Your domain name
  3) selfsigned : Place this to self signed the host
  Example: ./install.sh http"
  exit $?
fi

mkdir -p certs/ certs-data/ nginx/ logs/nginx/ mysql/ wordpress/

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
  sed -i 's/FQDN_OR_IP/localhost/gi' ../nginx/default.conf
  sed -i 's/ssl_trusted_certificate/#ssl_trusted_certificate/gi' ../nginx/default.conf
fi

echo ">>> Run the stack: Mysql / Wordpress / Nginx"
docker-compose up -d