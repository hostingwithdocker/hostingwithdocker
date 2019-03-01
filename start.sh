#!/bin/bash
s=$BASH_SOURCE ; s=$(dirname "$s") ; s=$(cd "$s" && pwd) ; SCRIPT_HOME="$s" #get SCRIPT_HOME=executed script's path, containing folder, cd & pwd to get container path

manual='\
MANUAL
  This script needs 3 arguments
  $1 http|https  a.k.a.   the type of web server
  $2 domain name e.g.     www.example.com, localhost
  $3 selfsigned           (optional) set this to self-signed the host

  E.g.
  ./start.sh http
  ./start.sh http localhost
  LOAD_DATADUMP_FILE=./initdb/data.sql ./start.sh http localhost
'

# load params
  http_type=$1
     domain=$2
 selfsigned=$3

if [[ -z $http_type ]]; then http_type='http';    fi
if [[ -z $domain    ]]; then domain='localhost';  fi

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


if [[ "$selfsigned" = "selfsigned" ]]; then # selfsigned domain loading
  cd ./letsenscrypt
    ./self-signed-init.sh $domain
    sed -i  -e "s/FQDN_OR_IP/$domain/g" ../nginx/default.conf
    sed -i  -e 's/ssl_trusted_certificate/#ssl_trusted_certificate/g' ../nginx/default.conf
  cd --

else # domain loading
    sed -i  -e "s/FQDN_OR_IP/$domain/g" ./nginx/default.conf
    # FQDN_OR_IP aka full-qualified domain-name or ip
fi


# start the app aka the docker stack
echo ">>> Run the stack: Mysql / Wordpress / Nginx"
docker-compose up -d

# Load env by eval then import db
if [ "${LOAD_DATADUMP_FILE}" != ""  ]; then
  echo ">>> Waiting for 15 seconds for starting the MySQL service then start to import database"
  sleep 15
  (eval $(egrep -v '^#' .env | xargs) && docker exec -i ${STACK_PREFIX}mysql mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < ./initdb/data.sql)
fi

echo "\
View access log  tail -f $SCRIPT_HOME/logs/nginx/access.log
View error log   tail -f $SCRIPT_HOME/logs/nginx/error.log
"