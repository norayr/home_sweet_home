#!/bin/sh
media-ctl -d /dev/media1 --links '"gc2145 4-003c":0->"sun6i-csi-bridge":0[0]'
media-ctl -d /dev/media1 --links '"ov5640 4-004c":0->"sun6i-csi-bridge":0[1]'

# Set image parameters on the rear camera entity
media-ctl -d /dev/media1 --set-v4l2 '"ov5640 4-004c":0[fmt:UYVY8_2X8/1280x720]'

# Verify connections
media-ctl -d /dev/media1 -p

/usr/bin/megapixels
