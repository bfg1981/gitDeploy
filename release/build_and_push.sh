#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [ ! -f $SCRIPT_DIR/TAG_NAME ]
then
  echo "You need to write the name of the tag in '$SCRIPT_DIR/TAG_NAME'"
  exit 1
fi

TAG_NAME=$(cat $SCRIPT_DIR/TAG_NAME)

fname=$(mktemp)

docker build --pull . | tee $fname

TAG_ID=$(tail -n 1 $fname | rev | cut -d\  -f1 | rev)
rm $fname

docker tag $TAG_ID $TAG_NAME
echo Tagged $TAG_NAME
docker push $TAG_NAME
