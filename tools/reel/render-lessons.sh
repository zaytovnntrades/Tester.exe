#!/usr/bin/env bash
# Renders the finished lessons (Remotion + free voice + captions) to renders/final/dNN.mp4, then checks every file.
# Needs voice files first: python tools/voice/make_voice.py   Run from anywhere: bash tools/reel/render-lessons.sh [d01 d02 ...]
set -u
cd "$(dirname "$0")"; ./sync-lesson.sh; mkdir -p ../../renders/final
ids="$*"; [ -z "$ids" ] && ids=$(node -e "console.log(require('../studio/series.js').ORDER.join(' '))")
for id in $ids; do
  npx remotion render src/index.ts Lesson ../../renders/final/$id.mp4 --props="{\"id\":\"$id\",\"captions\":true}" --log=error 2>&1 | grep -v "lower amount\|docker\|^$" | tail -2
  f=../../renders/final/$id.mp4
  v=$(ffprobe -v error -select_streams v -show_entries stream=duration -of csv=p=0 $f 2>/dev/null); a=$(ffprobe -v error -select_streams a -show_entries stream=duration -of csv=p=0 $f 2>/dev/null)
  if [ -z "$v" ] || [ -z "$a" ]; then echo "BROKEN $id (video=$v audio=$a)"; else echo "ok $id video ${v}s audio ${a}s"; fi
done
echo "RENDER-LESSONS FINISHED"
