#!/bin/bash

# Set the base directory where the episode directories are located
BASE_DIR="/srv/www/norayr.am/htdocs/sets/performances"

# Output file for the spotlight feed
SPOTLIGHT_FEED="/srv/www/norayr.am/htdocs/sets/spotlight.xml"

# Output file for the spotlight Gemini file
SPOTLIGHT_GMI="/srv/www/norayr.am/htdocs/sets/spotlight.gmi"

# Path to spotlight.txt
SPOTLIGHT_LIST="/srv/www/norayr.am/htdocs/sets/spotlight.txt"

# Temporary file to collect RSS items
SPOTLIGHT_ITEMS=$(mktemp)

# Standard image dimensions
STANDARD_WIDTH=800
STANDARD_HEIGHT=800

# Initialize spotlight.gmi
cat <<EOF > "$SPOTLIGHT_GMI"
# inky's spotlight live sets and performances
=> gemini://norayr.am/sets/index.gmi all sets here

EOF

# Function to process each episode directory
process_spotlight_episode() {
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

  # Find existing audio files
  AUDIO_FILE_MP3=$(ls -1t *[0-9a-zA-Z]*_320k.mp3 *.mp3 2>/dev/null | head -n 1)
  AUDIO_FILE_OGG=$(ls -1t *.ogg 2>/dev/null | head -n 1)

  # Check if at least one of the audio files exists
  if [[ -z "$AUDIO_FILE_MP3" ]] && [[ -z "$AUDIO_FILE_OGG" ]]; then
    echo "No audio files available in $EPISODE_DIR"
    return
  fi

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
  EPISODE_GUID="$EPISODE_URL"

  # Determine which audio file to use for the feed
  if [[ -n "$AUDIO_FILE_MP3" ]] && [[ -f "$AUDIO_FILE_MP3" ]]; then
    AUDIO_FILE="$AUDIO_FILE_MP3"
    AUDIO_URL="$EPISODE_URL$(basename "$AUDIO_FILE_MP3")"
    ENCLOSURE_TYPE="audio/mpeg"
  elif [[ -n "$AUDIO_FILE_OGG" ]] && [[ -f "$AUDIO_FILE_OGG" ]]; then
    AUDIO_FILE="$AUDIO_FILE_OGG"
    AUDIO_URL="$EPISODE_URL$(basename "$AUDIO_FILE_OGG")"
    ENCLOSURE_TYPE="audio/ogg"
  else
    echo "No valid audio file found in $EPISODE_DIR"
    return
  fi

  # Get the duration of the audio file
  DURATION=$(ffprobe -i "$AUDIO_FILE" -show_entries format=duration -v quiet -of csv="p=0" | \
    awk '{printf("%d:%02d:%02d", $1/3600, ($1%3600)/60, $1%60)}')

  # Add item to spotlight RSS items
  cat <<EOF >> "$SPOTLIGHT_ITEMS"
    <item>
      <title>$EPISODE_TITLE</title>
      <link>$EPISODE_URL</link>
      <guid isPermaLink="false">$EPISODE_GUID</guid>
      <pubDate>$EPISODE_DATE</pubDate>
      <description><![CDATA[<img src="$IMAGE_URL" alt="Episode Cover" /><br/>You can also listen to the episode <a href="$AUDIO_URL">here</a>.]]></description>
      <enclosure url="$AUDIO_URL" type="$ENCLOSURE_TYPE" />
      <itunes:summary>$EPISODE_TITLE</itunes:summary>
      <itunes:image href="https://norayr.am$IMAGE_URL" />
      <itunes:duration>$DURATION</itunes:duration>
      <itunes:explicit>no</itunes:explicit>
      <category>electronic</category>
    </item>
EOF

  # Add entry to spotlight.gmi (using OGG file if available, else MP3)
  if [[ -z "$EPISODE_DATE_DIR" ]]; then
    EPISODE_DATE_DIR="Unknown Date"
  fi

  # Construct relative audio path for Gemini
  if [[ -n "$AUDIO_FILE_OGG" ]] && [[ -f "$AUDIO_FILE_OGG" ]]; then
    RELATIVE_AUDIO_PATH="performances/$(basename "$EPISODE_DIR")/$(basename "$AUDIO_FILE_OGG")"
  else
    RELATIVE_AUDIO_PATH="performances/$(basename "$EPISODE_DIR")/$(basename "$AUDIO_FILE_MP3")"
  fi

  echo "=> $IMAGE_URL Episode Cover" >> "$SPOTLIGHT_GMI"
  echo "=> $RELATIVE_AUDIO_PATH $EPISODE_DATE_DIR $EPISODE_TITLE" >> "$SPOTLIGHT_GMI"

  cd "$BASE_DIR" || exit
}

# Start the Spotlight RSS feed
cat <<EOF > "$SPOTLIGHT_FEED"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
<channel>
  <title>inky from the tape - Spotlight Sets</title>
  <link>https://norayr.am</link>
  <description><![CDATA[Highlighted live sets and performances by inky. See video recordings <a href="https://toobnix.org/c/tanakian_channel/videos">on toobnix.org</a>]]></description>
  <language>en-us</language>
  <itunes:author>inky from the tape</itunes:author>
  <itunes:summary>Highlighted live sets and performances by inky.</itunes:summary>
  <itunes:owner>
    <itunes:name>inky from the tape</itunes:name>
    <itunes:email>norayr@norayr.am</itunes:email>
  </itunes:owner>
  <itunes:explicit>no</itunes:explicit>
  <itunes:image href="https://norayr.am/sets/performances/test.jpg" />
EOF

# Read directories from spotlight.txt and process them
while read -r EPISODE_NAME; do
  EPISODE_DIR="$BASE_DIR/$EPISODE_NAME"
  if [[ -d "$EPISODE_DIR" ]]; then
    process_spotlight_episode "$EPISODE_DIR"
  else
    echo "Directory not found: $EPISODE_DIR"
  fi
done < "$SPOTLIGHT_LIST"

# Finish the Spotlight RSS feed
echo "</channel></rss>" >> "$SPOTLIGHT_FEED"

# Insert RSS items into the feed
sed -i '/<\/channel>/e cat '"$SPOTLIGHT_ITEMS" "$SPOTLIGHT_FEED"

# Clean up temporary files
rm "$SPOTLIGHT_ITEMS"

# Copy spotlight.gmi to the Gemini directory
cp "$SPOTLIGHT_GMI" /srv/gemini/norayr.am/pub/sets/

echo "Spotlight RSS feed generated at $SPOTLIGHT_FEED"
echo "Spotlight GMI generated at $SPOTLIGHT_GMI"

