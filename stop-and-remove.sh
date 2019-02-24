#!/usr/bin/env bash

: stop running containers and clean-up all related resources

auto_yes=$1
if [[ ! -z $auto_yes ]]; then
  # it's auto_yes=true --> no prompt
  answer='y'

else
  # show confirm prompt
  read -p "Do you really want to stop and remove EVERYTHING (Y/n)? " answer

  # default as Y
  if [[ -z $answer ]]; then
    answer='Y'
  fi
fi

case ${answer:0:1} in
    y|Y )
        echo "INFO: Stopping containers"; docker-compose stop
        echo "INFO: Removing containers"; docker-compose rm -f

        echo "INFO: Setting file permissions to that of the user"
        docker run  --rm \
                    -v $(pwd):/clean \
                    -e UID=$(id -u) \
                    -e GID=$(id -g) \
                    nginx:latest /bin/bash -c 'chown -R $UID:$GID /clean'

        echo "INFO: Pruning unused docker volumes";   docker volume prune -f
        echo "INFO: Pruning unused docker networks";  docker network prune -f

        echo "INFO: Removing directories and contents (certs/ certs-data/ logs/nginx/ mysql/ wordpress/)"
        rm -rf certs/ certs-data/ nginx/ logs/nginx/ mysql/ wordpress/

        echo "INFO: Done"
        exit 0;
    ;;
    * )
        echo "INFO: Exiting without stopping containers or removing files"
        exit 0;
    ;;
esac

exit 0;
