#!/bin/sh

source=$1
destination=$2

if ! [ -d "$source" ]; then
  echo "Invalid source directory"

  exit 1
fi

if ! [ -d "$destination" ]; then
  echo "Invalid destination directory"

  exit 1
fi


echo "Backing up $source to $destination..."

trap "echo Exited!; exit;" SIGINT SIGTERM

MAX_RETRIES=50
i=0

# Set the initial return value to failure
false

currentdate=$(date +'%Y-%m-%dT%H-%M')
finaldestination="$destination/$currentdate"
mkdir "$finaldestination"

while [ $? -ne 0 -a $i -lt $MAX_RETRIES ]
do
 i=$(($i+1))
 rsync -avzs --progress --partial --append "$source/" "$finaldestination/"
done

if [ $i -eq $MAX_RETRIES ]
then
  echo "Hit maximum number of retries, giving up."
else
  echo "Finished backing up."
  touch "$finaldestination.finished.txt"
fi
