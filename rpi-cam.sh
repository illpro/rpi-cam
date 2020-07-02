#!/bin/bash

# @package rpi-cam
# @author Zachary Segal <zach@illproductions.com>
# @version 1.0

# This script will setup a ram disk and start a "ring recording" type video
# stream. To display the video stream point a html5 video tag at this path:
# /mnt/rpi-cam-ramdisk/stream.m3u8

RAMDISK="/mnt/rpi-cam-ramdisk"
RAMDISK_TYPE="tmpfs"
RAMDISK_SIZE="32M"
VIDEO_WIDTH="720"
VIDEO_HEIGHT="420"
VIDEO_FPS="25"
VIDEO_BITRATE="1400000"

if [ ! -d "$RAMDISK" ]; then
    mkdir -p $RAMDISK
    mount -t $RAMDISK_TYPE -o size=$RAMDISK_SIZE $RAMDISK_TYPE $RAMDISK
    echo "* Made RAM Disk"
fi

# start a raspivid process, you can install this with aptitude iirc
start() {
  raspivid -n \
    -w $VIDEO_WIDTH \
    -h $VIDEO_HEIGHT \
    -fps $VIDEO_FPS \
    -ex auto \
    -awb auto \
    -t 0 \
    -b $VIDEO_BITRATE \
    -ih -o - \
  | ffmpeg -y \
    -i - \
    -an \
    -c:v copy \
    -map 0:0 \
    -f segment \
    -segment_time 3 \
    -segment_wrap 20 \
    -segment_format mpegts \
    -segment_list "$RAMDISK/stream.m3u8" \
    -segment_list_size $VIDEO_HEIGHT \
    -segment_list_flags live \
    -segment_list_type m3u8 \
    "$RAMDISK/%08d.ts"
}

# removes ram disk contents
# @TODO completely remove the ram disk
cleanup() {
  rm $RAMDISK/*.ts
  rm $RAMDISK/stream.m3u8
}



# handle command line arguments
case "$1" in
  cleanup)
    cleanup
    ;;
  *)
    start
    ;;
esac
