#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [ ! -f $SCRIPT_DIR/REPO_NAME ]
then
  echo "You need to write the name of the repo in '$SCRIPT_DIR/REPO_NAME'"
  exit 1
fi

REPO_NAME=$(cat $SCRIPT_DIR/REPO_NAME)

if [ -n "$1" ]
then
  TAG_NAME=$REPO_NAME:$1
else
  TAG_NAME=$REPO_NAME
fi

echo Tag name is "'$TAG_NAME'"

fname=$(mktemp)

docker build --pull . | tee $fname

TAG_ID=$(tail -n 1 $fname | rev | cut -d\  -f1 | rev)
rm $fname

docker tag $TAG_ID $TAG_NAME
echo Tagged $TAG_NAME
docker push $TAG_NAME
