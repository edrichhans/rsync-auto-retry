#!/bin/sh

source=/mnt/mmcblk0p1/DCIM/100GOPRO/
destination=/mnt/One\ Touch/Go\ Pro/
event=$(date +'%Y-%m-%d')

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

nohup ./gopro-backup-sync.sh -s "$source" -d "$destination" -e "$event" > "$event"_output.log 2>&1 &
echo $! > "$event"_pid.txt

echo "Created the background job to transfer files. Run the following command to monitor:"
echo tail -f "$event"_output.log
