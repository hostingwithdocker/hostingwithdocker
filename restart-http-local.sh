#!/bin/bash
s=$BASH_SOURCE ; s=$(dirname "$s") ; s=$(cd "$s" && pwd) ; SCRIPT_HOME="$s" #get SCRIPT_HOME=executed script's path, containing folder, cd & pwd to get container path
$SCRIPT_HOME/stop-and-remove.sh 1
$SCRIPT_HOME/start.sh http localhost
