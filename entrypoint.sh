#!/bin/sh

SOURCE_DIR=/var/www/localhost/htdocs

(cd /opt/python-github-webhook && python /opt/python-github-webhook/run.py) &

if [ ! -d $SOURCE_DIR/.git ]
then
   rm $SOURCE_DIR/*
   git clone $GIT_SOURCE $SOURCE_DIR
else
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
