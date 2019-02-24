#!/bin/bash

# initials
s=$BASH_SOURCE ; s=$(dirname "$s") ; s=$(cd "$s" && pwd) ; SCRIPT_HOME="$s" #get SCRIPT_HOME=executed script's path, containing folder, cd & pwd to get container path

RED='\033[1;31m'; GRE='\033[1;32m'; dGRE='\033[0;33m'; ENC='\033[0m' # ENC aka. end color
PASS="${GRE}PASS${ENC}"; FAIL="${RED}FAIL${ENC}"
function pass_or_fail() {
      if [[ 0 -eq $? ]]; then
          printf " $PASS \n"
      else
          printf " $FAIL \n"
          cat_log | grep -v '/html'
      fi
  }


# start aftermath-wise
source $SCRIPT_HOME/.env
 http_p=$NGINX_HTTP_PORT
https_p=$NGINX_HTTPS_PORT

if [[ -z $http_p ]];  then http_p=80;   fi
if [[ -z $https_p ]]; then https_p=443; fi

echo -e "\
Loading config...
  http  served at ${dGRE}$http_p${ENC}
  https served at ${dGRE}$https_p${ENC}
"

echo 'Aftermath testing...' >/dev/null

  function cat_log() {
    echo "  $(tail -n1 /Users/namgivu/NN/code/opensource/hostingwithdocker-2/aftermath-test.log)"
    echo
  }

  nginx_config="$SCRIPT_HOME/nginx/default.conf"
  server_name=$( cat $nginx_config | grep server_name | rev | cut -d' ' -f1 | rev | sed 's/;//g' )
  printf "Testing server_name='${dGRE}$server_name${ENC}'"
  if [[ $server_name != 'FQDN_OR_IP' ]]; then echo -e " $PASS"; else echo -e " $FAIL"; fi

  echo

  log="$SCRIPT_HOME/aftermath-test.log"

  echo 'Testing wordpress status...'
    c1="curl -sS -I http://$server_name:$http_p 2>&1  | head -n 1  | cut -d ' ' -f2-";      s=`eval $c1`;
    c2="curl -sS -I http://$server_name:$http_p 2>&1  | head -n 1  | cut -d ' ' -f2 "; s_code=`eval $c2`;

    case $s_code in #TODO add more error http code here
      502|400) status=$FAIL ;;
            *) status=$PASS ;;
    esac

    echo -e "\
  $c1 ... $status
  $c2 ... $status
  code: ${dGRE}$s_code${ENC}  status: ${dGRE}$s${ENC}
"

  if [[ "$status" == "$PASS" ]]; then
    echo 'Testing wordpress endpoints...'
    c="curl -sS http://$server_name:$http_p/wp_admin 1>>$log 2>&1"; c_nd=$(echo $c | rev | cut -d' ' -f3- | rev); printf "  $c_nd ..."; eval $c; pass_or_fail # c_nd aka command no redirect
    c="curl -sS http://$server_name:$http_p          1>>$log 2>&1"; c_nd=$(echo $c | rev | cut -d' ' -f3- | rev); printf "  $c_nd ..."; eval $c; pass_or_fail # c_nd aka command no redirect
  fi

echo "
More details in
log=$log; cat \$log

Done
"