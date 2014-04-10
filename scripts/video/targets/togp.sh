#!/bin/bash
# run as ./togp.sh sourcevideo out.3gp
ffmpeg -i $1 -s 176x144 -acodec libfaac -ac 1 -ar 32000 -ab 32 $2
#ffmpeg -i $1 -s 220x124 -acodec libfaac -ac 1 -ar 32000 -ab 32 $2

