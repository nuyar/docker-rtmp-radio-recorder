#!/bin/bash

# rtmp_addr time(m) filename directory

RADIO_ADDR=$1

RADIO_NAME="ebs_radio"

RECORD_MINS=$(($2 * 60))

PROGRAM_NAME=$3

DEST_DIR="/recorded/$4"


REC_DATE=`date +%y%m%d_%H%M`

TEMP_FLV=`mktemp -u`

MP3_FILE_NAME=$PROGRAM_NAME"_"$REC_DATE.mp3


echo "(`date +%y%m%d-%H%M`) start recording $PROGRAM_NAME $REC_DATE"
echo "(`date +%y%m%d-%H%M`) start dumping $PROGRAM_NAME $REC_DATE"
rtmpdump -r $RADIO_ADDR -B $RECORD_MINS -o $TEMP_FLV  2> /dev/null
echo "(`date +%y%m%d-%H%M`) finished dumping $PROGRAM_NAME $REC_DATE"

echo "(`date +%y%m%d-%H%M`) start converting $PROGRAM_NAME $REC_DATE"
ffmpeg -i $TEMP_FLV -ac 2 -ab 128k -vn -y  -f mp3 $MP3_FILE_NAME 2> /dev/null
echo "(`date +%y%m%d-%H%M`) finished converting $PROGRAM_NAME $REC_DATE"

rm $TEMP_FLV
echo "(`date +%y%m%d-%H%M`) removed temp file of $PROGRAM_NAME $REC_DATE"

mkdir -p $DEST_DIR

mv $MP3_FILE_NAME $DEST_DIR
echo "(`date +%y%m%d-%H%M`) finished recording $PROGRAM_NAME $REC_DATE"