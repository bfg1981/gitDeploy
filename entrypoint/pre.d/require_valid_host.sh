#!/bin/sh

HOSTNAME=$(hostname)
if [[ $HOSTNAME =~ ^[0-9A-Fa-f]{12}$ ]]
then
    echo "'$HOSTNAME' is most probably a random generated Docker hostname"
    echo "Please consider setting the hostname explicitly"
fi

if [ -n "$VIRTUAL_HOST" ]
then
  echo Found host "$VIRTUAL_HOST"
  if [ -n "$FORCE_VIRTUAL_HOST" ] && [ "$FORCE_VIRTUAL_HOST" -gt 0 ]
  then
    echo FORCING VIRTUAL_HOST
  else
    if nslookup $VIRTUAL_HOST >/dev/null
    then
      echo "$VIRTUAL_HOST" resolves
    else
       echo "$VIRTUAL_HOST" does not resolve and FORCE_VIRTUAL_HOST is not set
       echo ABORTING
       exit 1
    fi
  fi
fi
