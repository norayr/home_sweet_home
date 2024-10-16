#!/bin/bash

# Set the base directory where the episode directories are located
BASE_DIR="/srv/www/norayr.am/htdocs/sets/performances"

# Output files
RSS_FEED="/srv/www/norayr.am/htdocs/sets/feed.xml"
INDEX_HTML="/srv/www/norayr.am/htdocs/sets/index.html"
INDEX_GMI="/srv/www/norayr.am/htdocs/sets/index.gmi"

# Temporary file to collect RSS items
RSS_ITEMS=$(mktemp)

# Standard image dimensions
STANDARD_WIDTH=800
STANDARD_HEIGHT=800

# Function to process each episode directory
process_episode() {
  EPISODE_DIR="$1"
  echo "Processing directory: $EPISODE_DIR"

  cd "$EPISODE_DIR" || return

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

  # Find the last _320k.mp3 or .mp3 file
  AUDIO_FILE=$(ls -1t *[0-9a-zA-Z]*_320k.mp3 *.mp3 2>/dev/null | head -n 1)
  if [[ -z "$AUDIO_FILE" ]]; then
    # Look for .wav or .flac files to convert
    SOURCE_AUDIO=$(ls -1t *.[wW][aA][vV] *.[fF][lL][aA][cC] 2>/dev/null | head -n 1)
    if [[ -n "$SOURCE_AUDIO" ]]; then
      AUDIO_FILE="${SOURCE_AUDIO%.*}_320k.mp3"
      if [[ ! -f "$AUDIO_FILE" ]]; then
        echo "Converting $SOURCE_AUDIO to $AUDIO_FILE"
        ffmpeg -i "$SOURCE_AUDIO" -b:a 320k "$AUDIO_FILE"
      fi
    else
      echo "No audio file to process in $EPISODE_DIR"
      return
    fi
  fi

  # Generate index.html in the episode directory
  EPISODE_HTML="$EPISODE_DIR/index.html"
  cat <<EOF > "$EPISODE_HTML"
<!DOCTYPE html>
<html>
<head>
  <title>$(basename "$EPISODE_DIR")</title>
</head>
<body>
  <h1>$(basename "$EPISODE_DIR")</h1>
  <img src="$IMAGE_URL" alt="Episode Cover" style="max-width:100%;">
  <audio controls>
    <source src="$(basename "$AUDIO_FILE")" type="audio/mpeg">
    Your browser does not support the audio element.
  </audio>
</body>
</html>
EOF

  # Generate index.gmi in the episode directory
  EPISODE_GMI="$EPISODE_DIR/index.gmi"
  RELATIVE_AUDIO_PATH="performances/$(basename "$EPISODE_DIR")/$(basename "$AUDIO_FILE")"
  cat <<EOF > "$EPISODE_GMI"
# $(basename "$EPISODE_DIR")

=> $IMAGE_URL Episode Cover

=> $RELATIVE_AUDIO_PATH Listen to the episode
EOF

  # Collect metadata for RSS feed
  EPISODE_TITLE=$(basename "$EPISODE_DIR" | sed 's/[-_]/ /g')
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
  AUDIO_URL="$EPISODE_URL$(basename "$AUDIO_FILE")"
  EPISODE_GUID="$EPISODE_URL"

  # Get the duration of the audio file
  DURATION=$(ffprobe -i "$AUDIO_FILE" -show_entries format=duration -v quiet -of csv="p=0" | awk '{printf("%d:%02d:%02d", $1/3600, ($1%3600)/60, $1%60)}')

  # Add item to RSS items
  cat <<EOF >> "$RSS_ITEMS"
    <item>
      <title>$EPISODE_TITLE</title>
      <link>$EPISODE_URL</link>
      <guid isPermaLink="false">$EPISODE_GUID</guid>
      <pubDate>$EPISODE_DATE</pubDate>
      <description><![CDATA[<img src="$IMAGE_URL" alt="Episode Cover: inky plays at mirzoian library" /><br/>You can also listen to the episode <a href="$AUDIO_URL">here</a>.]]></description>
      <enclosure url="$AUDIO_URL" type="audio/mpeg" />
      <itunes:summary>Podcast episode summary.</itunes:summary>
      <itunes:image href="https://norayr.am$IMAGE_URL" />
      <itunes:duration>$DURATION</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <category>anonradio</category>
      <category>set</category>
      <category>electronic</category>
      <category>անոնռադիօ</category>
      <category>սէթ</category>
      <category>էլեկտրոնային</category>
    </item>
EOF

  # Add entry to index.html
  echo "<h2><a href=\"$EPISODE_URL\">$EPISODE_TITLE</a></h2>" >> "$INDEX_HTML"
  echo "<p><img src=\"$IMAGE_URL\" alt=\"Episode Cover\" style=\"max-width:100%;\"></p>" >> "$INDEX_HTML"
  echo "<audio controls><source src=\"$AUDIO_URL\" type=\"audio/mpeg\">Your browser does not support the audio element.</audio>" >> "$INDEX_HTML"
  echo "<hr/>" >> "$INDEX_HTML"

  # Add entry to index.gmi
  echo "=> $AUDIO_URL $EPISODE_DATE_DIR $EPISODE_TITLE" >> "$INDEX_GMI"

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

# Start the RSS feed
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

# Collect all episode directories and sort them in reverse chronological order based on directory names
EPISODE_DIRS=$(ls -1d "$BASE_DIR"/*/ | sort -r)

# Process each episode directory
for EPISODE_DIR in $EPISODE_DIRS; do
  if [[ -d "$EPISODE_DIR" ]]; then
    process_episode "$EPISODE_DIR"
  fi
done

# Finish the RSS feed
echo "</channel></rss>" >> "$RSS_FEED"

# Insert RSS items into the feed
sed -i '/<\/channel>/e cat '"$RSS_ITEMS" "$RSS_FEED"

# Clean up temporary files
rm "$RSS_ITEMS"

# Finish index.html
echo "</body></html>" >> "$INDEX_HTML"

echo "RSS feed generated at $RSS_FEED"
echo "Index HTML generated at $INDEX_HTML"
echo "Index GMI generated at $INDEX_GMI"
sed -i 's|https://norayr.am/sets/||' $INDEX_GMI
cp $INDEX_GMI /srv/gemini/norayr.am/pub/sets/
