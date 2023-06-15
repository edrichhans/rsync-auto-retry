#!/bin/sh

while getopts ":s:d:e:" option; do
  case $option in
    s)
      source="$OPTARG"
      ;;
    d)
      destination="$OPTARG"
      ;;
    e)
      event="$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-s source] [-d destination] [-e event_name]"
      exit 1
      ;;
  esac
done

if [ -z "$event" ]; then
    echo "No event provided. Please provide an event name using -e"

    exit 1
fi

if ! [ -d "$source" ]; then
  echo "Invalid source directory"

  exit 1
fi

if ! [ -d "$destination" ]; then
  echo "Invalid destination directory"

  exit 1
fi


echo "Backing up $source to $destination/$event..."

trap "echo Exited!; exit;" SIGINT SIGTERM

MAX_RETRIES=50
i=0

# Set the initial return value to failure
false

finaldestination="$destination/$event"
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
