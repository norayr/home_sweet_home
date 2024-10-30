#!/bin/bash

# Set the base directory where the episode directories are located
BASE_DIR="/srv/www/norayr.am/htdocs/sets/performances"

# Output files
RSS_FEED="/srv/www/norayr.am/htdocs/sets/feed.xml"
OGG_FEED="/srv/www/norayr.am/htdocs/sets/ogg.xml"
INDEX_HTML="/srv/www/norayr.am/htdocs/sets/index.html"
INDEX_GMI="/srv/www/norayr.am/htdocs/sets/index.gmi"

# Temporary files to collect RSS items
RSS_ITEMS=$(mktemp)
OGG_ITEMS=$(mktemp)

# Standard image dimensions
STANDARD_WIDTH=800
STANDARD_HEIGHT=800

# Function to process each episode directory
process_episode() {
  EPISODE_DIR="$1"
  echo "Processing directory: $EPISODE_DIR"

  cd "$EPISODE_DIR" || return

# Episode metadata
  EPISODE_TITLE=$(basename "$EPISODE_DIR")
  EPISODE_TITLE_FORMATTED=$(echo "$EPISODE_TITLE" | sed 's/[-_]/ /g')
  ARTIST="inky from the tape"
  GENRE="Electronic"

  # Find the last image file (case-insensitive)
  IMAGE_FILE=$(ls -1t *.[jJ][pP][gG] *.[pP][nN][gG] 2>/dev/null | head -n 1)
  if [[ -z "$IMAGE_FILE" ]]; then
    echo "No image file found in $EPISODE_DIR. Using default image."
    # Use the default image
    IMAGE_FILE="/srv/www/norayr.am/htdocs/sets/performances/test.jpg"
    IMAGE_URL="/sets/performances/test.jpg"
  else
    # Resize the image if it's too big
    IMAGE_PATH="$EPISODE_DIR/$IMAGE_FILE"
    DIMENSIONS=$(identify -format "%w %h" "$IMAGE_PATH")
    WIDTH=$(echo "$DIMENSIONS" | awk '{print $1}')
    HEIGHT=$(echo "$DIMENSIONS" | awk '{print $2}')
    if [[ $WIDTH -gt $STANDARD_WIDTH ]] || [[ $HEIGHT -gt $STANDARD_HEIGHT ]]; then
      echo "Resizing image $IMAGE_FILE to ${STANDARD_WIDTH}x${STANDARD_HEIGHT}"
      RESIZED_IMAGE_FILE="resized_$IMAGE_FILE"
      convert "$IMAGE_FILE" -resize "${STANDARD_WIDTH}x${STANDARD_HEIGHT}" "$RESIZED_IMAGE_FILE"
      IMAGE_FILE="$RESIZED_IMAGE_FILE"
    fi
    IMAGE_URL="/sets/performances/$(basename "$EPISODE_DIR")/$IMAGE_FILE"
  fi

  # Find existing audio files
  AUDIO_FILE_MP3=$(ls -1t *[0-9a-zA-Z]*_320k.mp3 *.mp3 2>/dev/null | head -n 1)
  AUDIO_FILE_OGG=$(ls -1t *.ogg 2>/dev/null | head -n 1)

  # If MP3 or OGG files don't exist, look for source audio files
  if [[ -z "$AUDIO_FILE_MP3" ]] || [[ -z "$AUDIO_FILE_OGG" ]]; then
    # Reset SOURCE_AUDIO
    SOURCE_AUDIO=""

    # Try to find the latest .wav or .WAV file
    SOURCE_AUDIO=$(ls -1t *.[wW][aA][vV] 2>/dev/null | head -n 1)

    # If no .wav file found, try .flac files
    if [[ -z "$SOURCE_AUDIO" ]]; then
      SOURCE_AUDIO=$(ls -1t *.[fF][lL][aA][cC] 2>/dev/null | head -n 1)
    fi

    # If no .wav or .flac file found, try .mp4 files
    if [[ -z "$SOURCE_AUDIO" ]]; then
      SOURCE_AUDIO=$(ls -1t *.[mM][pP]4 2>/dev/null | head -n 1)
    fi

    # If no source audio file found, output an error
    if [[ -z "$SOURCE_AUDIO" ]]; then
      echo "No audio source file to process in $EPISODE_DIR"
      return
    fi

    # Convert to MP3 if needed
    if [[ -z "$AUDIO_FILE_MP3" ]]; then
      AUDIO_FILE_MP3="${SOURCE_AUDIO%.*}_320k.mp3"
      echo "Converting $SOURCE_AUDIO to $AUDIO_FILE_MP3 with metadata"
      ffmpeg -i "$SOURCE_AUDIO" -b:a 320k \
        -metadata title="$EPISODE_TITLE" \
        -metadata artist="$ARTIST" \
        -metadata genre="$GENRE" \
        "$AUDIO_FILE_MP3"
    fi

    # Convert to OGG if needed
    if [[ -z "$AUDIO_FILE_OGG" ]]; then
      AUDIO_FILE_OGG="${SOURCE_AUDIO%.*}.ogg"
      echo "Converting $SOURCE_AUDIO to $AUDIO_FILE_OGG with highest quality and metadata"
      ffmpeg -i "$SOURCE_AUDIO" -c:a libvorbis -qscale:a 10 \
        -metadata title="$EPISODE_TITLE" \
        -metadata artist="$ARTIST" \
        -metadata genre="$GENRE" \
        "$AUDIO_FILE_OGG"
    fi
  fi

  # Check if both audio files exist
  if [[ -z "$AUDIO_FILE_MP3" ]] && [[ -z "$AUDIO_FILE_OGG" ]]; then
    echo "No audio files available in $EPISODE_DIR"
    return
  fi

  # Generate index.html in the episode directory
  EPISODE_HTML="$EPISODE_DIR/index.html"
  cat <<EOF > "$EPISODE_HTML"
<!DOCTYPE html>
<html>
<head>
  <title>$EPISODE_TITLE</title>
</head>
<body>
  <h1>$EPISODE_TITLE</h1>
  <img src="$IMAGE_URL" alt="Episode Cover" style="max-width:100%;">
  <audio controls>
EOF
  if [[ -f "$AUDIO_FILE_MP3" ]]; then
    echo "    <source src=\"$(basename "$AUDIO_FILE_MP3")\" type=\"audio/mpeg\">" >> "$EPISODE_HTML"
  fi
  if [[ -f "$AUDIO_FILE_OGG" ]]; then
    echo "    <source src=\"$(basename "$AUDIO_FILE_OGG")\" type=\"audio/ogg\">" >> "$EPISODE_HTML"
  fi
  cat <<EOF >> "$EPISODE_HTML"
    Your browser does not support the audio element.
  </audio>
</body>
</html>
EOF

  # Generate index.gmi in the episode directory
  EPISODE_GMI="$EPISODE_DIR/index.gmi"
  RELATIVE_AUDIO_PATH="performances/$(basename "$EPISODE_DIR")/$(basename "$AUDIO_FILE_OGG")"
  cat <<EOF > "$EPISODE_GMI"
# $EPISODE_TITLE

=> $IMAGE_URL Episode Cover

=> $RELATIVE_AUDIO_PATH Listen to the episode
EOF

  # Collect metadata for RSS feeds
  # Extract date from directory name (assuming format YYYY-MM-DD)
  EPISODE_DATE_DIR=$(basename "$EPISODE_DIR" | grep -Eo '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
  if [[ -z "$EPISODE_DATE_DIR" ]]; then
    echo "Cannot extract date from directory name: $(basename "$EPISODE_DIR")"
    EPISODE_DATE=$(date -R)
  else
    # Set time to 03:00 AM
    EPISODE_DATE="$(date -d "$EPISODE_DATE_DIR 03:00:00" -R)"
  fi
  EPISODE_URL="https://norayr.am/sets/performances/$(basename "$EPISODE_DIR")/"
  AUDIO_URL_MP3="$EPISODE_URL$(basename "$AUDIO_FILE_MP3")"
  AUDIO_URL_OGG="$EPISODE_URL$(basename "$AUDIO_FILE_OGG")"
  EPISODE_GUID="$EPISODE_URL"

  # Get the duration of the audio file (use MP3 if available, else OGG)
  if [[ -f "$AUDIO_FILE_MP3" ]]; then
    DURATION=$(ffprobe -i "$AUDIO_FILE_MP3" -show_entries format=duration -v quiet -of csv="p=0" | awk '{printf("%d:%02d:%02d", $1/3600, ($1%3600)/60, $1%60)}')
  elif [[ -f "$AUDIO_FILE_OGG" ]]; then
    DURATION=$(ffprobe -i "$AUDIO_FILE_OGG" -show_entries format=duration -v quiet -of csv="p=0" | awk '{printf("%d:%02d:%02d", $1/3600, ($1%3600)/60, $1%60)}')
  else
    DURATION="00:00:00"
  fi

  # Add item to MP3 RSS items
  if [[ -f "$AUDIO_FILE_MP3" ]]; then
    cat <<EOF >> "$RSS_ITEMS"
    <item>
      <title>$EPISODE_TITLE_FORMATTED</title>
      <link>$EPISODE_URL</link>
      <guid isPermaLink="false">$EPISODE_GUID</guid>
      <pubDate>$EPISODE_DATE</pubDate>
      <description><![CDATA[<img src="$IMAGE_URL" alt="Episode Cover" /><br/>You can also listen to the episode <a href="$AUDIO_URL_MP3">here</a>.]]></description>
      <enclosure url="$AUDIO_URL_MP3" type="audio/mpeg" />
      <itunes:summary>$EPISODE_TITLE_FORMATTED</itunes:summary>
      <itunes:image href="https://norayr.am$IMAGE_URL" />
      <itunes:duration>$DURATION</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <category>electronic</category>
    </item>
EOF
  fi

  # Add item to OGG RSS items
  if [[ -f "$AUDIO_FILE_OGG" ]]; then
    cat <<EOF >> "$OGG_ITEMS"
    <item>
      <title>$EPISODE_TITLE_FORMATTED</title>
      <link>$EPISODE_URL</link>
      <guid isPermaLink="false">$EPISODE_GUID</guid>
      <pubDate>$EPISODE_DATE</pubDate>
      <description><![CDATA[<img src="$IMAGE_URL" alt="Episode Cover" /><br/>You can also listen to the episode <a href="$AUDIO_URL_OGG">here</a>.]]></description>
      <enclosure url="$AUDIO_URL_OGG" type="audio/ogg" />
      <itunes:summary>$EPISODE_TITLE_FORMATTED</itunes:summary>
      <itunes:image href="https://norayr.am$IMAGE_URL" />
      <itunes:duration>$DURATION</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <category>electronic</category>
    </item>
EOF
  fi

  # Add entry to index.html
  echo "<h2><a href=\"$EPISODE_URL\">$EPISODE_TITLE_FORMATTED</a></h2>" >> "$INDEX_HTML"
  echo "<p><img src=\"$IMAGE_URL\" alt=\"Episode Cover\" style=\"max-width:100%;\"></p>" >> "$INDEX_HTML"
  echo "<audio controls>" >> "$INDEX_HTML"
  if [[ -f "$AUDIO_FILE_MP3" ]]; then
    echo "<source src=\"$AUDIO_URL_MP3\" type=\"audio/mpeg\">" >> "$INDEX_HTML"
  fi
  if [[ -f "$AUDIO_FILE_OGG" ]]; then
    echo "<source src=\"$AUDIO_URL_OGG\" type=\"audio/ogg\">" >> "$INDEX_HTML"
  fi
  echo "Your browser does not support the audio element.</audio>" >> "$INDEX_HTML"
  echo "<hr/>" >> "$INDEX_HTML"

  # Add entry to index.gmi
  echo "=> $AUDIO_URL_OGG $EPISODE_DATE_DIR $EPISODE_TITLE_FORMATTED" >> "$INDEX_GMI"

  cd "$BASE_DIR" || exit
}

# Initialize index.html
cat <<EOF > "$INDEX_HTML"
<!DOCTYPE html>
<html>
<head>
  <title>inky from the tape sets</title>
</head>
<body>
  <h1>inky's live sets and performances</h1>
EOF

# Initialize index.gmi
cat <<EOF > "$INDEX_GMI"
# inky's live sets and performances

EOF

# Start the MP3 RSS feed
cat <<EOF > "$RSS_FEED"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
<channel>
  <title>inky from the tape sets</title>
  <link>https://norayr.am</link>
  <description><![CDATA[inky's live sets and performances, mostly played on anonradio.net, but also on bohemnots and other events, see video recordings <a href="https://toobnix.org/c/tanakian_channel/videos">on toobnix.org</a>]]></description>
  <language>en-us</language>
  <itunes:author>inky from the tape</itunes:author>
  <itunes:summary>inky's live sets and performances, see video recordings on toobnix.org (https://toobnix.org/c/tanakian_channel/videos)</itunes:summary>
  <itunes:owner>
    <itunes:name>inky from the tape</itunes:name>
    <itunes:email>norayr@norayr.am</itunes:email>
  </itunes:owner>
  <itunes:explicit>no</itunes:explicit>
  <itunes:image href="https://norayr.am/sets/performances/test.jpg" />
EOF

# Start the OGG RSS feed
cat <<EOF > "$OGG_FEED"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
<channel>
  <title>inky from the tape sets (OGG)</title>
  <link>https://norayr.am</link>
  <description><![CDATA[inky's live sets and performances in OGG format, mostly played on anonradio.net, but also on bohemnots and other events. See video recordings <a href="https://toobnix.org/c/tanakian_channel/videos">on toobnix.org</a>]]></description>
  <language>en-us</language>
  <itunes:author>inky from the tape</itunes:author>
  <itunes:summary>inky's live sets and performances in OGG format, see video recordings on toobnix.org (https://toobnix.org/c/tanakian_channel/videos)</itunes:summary>
  <itunes:owner>
    <itunes:name>inky from the tape</itunes:name>
    <itunes:email>norayr@norayr.am</itunes:email>
  </itunes:owner>
  <itunes:explicit>no</itunes:explicit>
  <itunes:image href="https://norayr.am/sets/performances/test.jpg" />
EOF

# Collect all episode directories and sort them in reverse chronological order based on directory names
EPISODE_DIRS=$(ls -1d "$BASE_DIR"/*/ | sort -r)

# Process each episode directory
for EPISODE_DIR in $EPISODE_DIRS; do
  if [[ -d "$EPISODE_DIR" ]]; then
    process_episode "$EPISODE_DIR"
  fi
done

# Finish the RSS feeds
echo "</channel></rss>" >> "$RSS_FEED"
echo "</channel></rss>" >> "$OGG_FEED"

# Insert RSS items into the feeds
sed -i '/<\/channel>/e cat '"$RSS_ITEMS" "$RSS_FEED"
sed -i '/<\/channel>/e cat '"$OGG_ITEMS" "$OGG_FEED"

# Clean up temporary files
rm "$RSS_ITEMS"
rm "$OGG_ITEMS"

# Finish index.html
echo "</body></html>" >> "$INDEX_HTML"

echo "RSS feed generated at $RSS_FEED"
echo "OGG RSS feed generated at $OGG_FEED"
echo "Index HTML generated at $INDEX_HTML"
echo "Index GMI generated at $INDEX_GMI"
sed -i 's|https://norayr.am/sets/||' $INDEX_GMI
cp $INDEX_GMI /srv/gemini/norayr.am/pub/sets/

