#!/bin/bash
s=$BASH_SOURCE ; s=$(dirname "$s") ; s=$(cd "$s" && pwd) ; SCRIPT_HOME="$s" #get SCRIPT_HOME=executed script's path, containing folder, cd & pwd to get container path

source $SCRIPT_HOME/.env
 http_p=$NGINX_HTTP_PORT
https_p=$NGINX_HTTPS_PORT

if [[ -z $http_p ]];  then http_p=80;   fi
if [[ -z $https_p ]]; then https_p=443; fi

echo "\
Loading config...
  http  served at $http_p
  https served at $https_p
"

echo "Aftermath testing..."
  RED='\033[1;31m'; GRE='\033[1;32m'; ENC='\033[0m' # ENC aka. end color
  PASS="${GRE}PASS${ENC}"; FAIL="${RED}FAIL${ENC}"
  function pass_or_fail() {
      if [[ 0 -eq $? ]]; then
          printf " $PASS \n"
      else
          printf " $FAIL \n"
          cat_log
      fi
  }

  function cat_log() {
    echo "  $(tail -n1 /Users/namgivu/NN/code/opensource/hostingwithdocker-2/aftermath-test.log)"
    echo
  }

  log="$SCRIPT_HOME/aftermath-test.log"
  c="curl -sS http://localhost:$http_p/wp_admin 1>>$log 2>&1"; c_nd=$(echo $c | rev | cut -d' ' -f3- | rev); printf "  $c_nd ..."; eval $c; pass_or_fail # c_nd aka command no redirect
  c="curl -sS http://localhost:$http_p          1>>$log 2>&1"; c_nd=$(echo $c | rev | cut -d' ' -f3- | rev); printf "  $c_nd ..."; eval $c; pass_or_fail # c_nd aka command no redirect

echo "
More details in log=$log
cat \$log

Done
"