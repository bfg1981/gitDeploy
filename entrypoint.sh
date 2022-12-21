#!/bin/sh

SOURCE_DIR=/var/www/localhost/htdocs

(cd /opt/python-github-webhook && python /opt/python-github-webhook/run.py) &

if [ -n "$FORCE_REINIT" ] && [ $FORCE_REINIT -gt 0 ]
then
  FORCE_REINIT=true
else
  FORCE_REINIT=false
fi

if $FORCE_REINIT ||  [ ! -d $SOURCE_DIR/.git ]
then
   echo CLEANING OLD FILES
   rm -rfv $SOURCE_DIR/.[!.]* $SOURCE_DIR/..?* $SOURCE_DIR/*
   echo INITIALIZING REPOSITORY
   git clone --recurse-submodules -j8 $GIT_SOURCE $SOURCE_DIR
else
   echo Using already exisiting source
   (cd $SOURCE_DIR && git pull)
fi

if [ -z "$HOOKS" ]
then
  HOOKS="postreceive"
fi

hookfile=/etc/apache2/conf.d/hooks.conf

for hook in $HOOKS
do
  echo ProxyPass /$hook http://localhost:5000/$hook | tee -a $hookfile
  echo ProxyPassReverse /$hook http://localhost:5000/$hook  | tee -a $hookfile 
done

exec /usr/sbin/httpd -DFOREGROUND
