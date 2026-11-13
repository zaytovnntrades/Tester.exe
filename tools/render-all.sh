#!/usr/bin/env bash
# Renders every clean video (days 1-30) and both versions of the polished Reel 005, then checks each file.
# Run from the repo root: bash tools/render-all.sh
set -u
cd "$(dirname "$0")/.."
mkdir -p renders/clean renders/reel
for v in 005 006 007 004 001 002; do node tools/studio/render.js tools/studio/$v-draft.html renders/clean/$v-clean.mp4 clean 2>&1 | tail -1; done
for id in $(node -e "console.log(require('./tools/studio/series.js').ORDER.join(' '))"); do
  node tools/studio/render.js tools/studio/basics.html renders/clean/$id-clean.mp4 "id=$id&clean" 2>&1 | tail -1
done
(cd tools/reel && npx remotion render src/index.ts Reel005 ../../renders/reel/005-reel-captions.mp4 --log=error && \
  npx remotion render src/index.ts Reel005 ../../renders/reel/005-reel-clean.mp4 --props='{"captions":false}' --log=error) 2>&1 | grep -v "lower amount\|docker\|^$" | tail -3
bad=0
for f in renders/clean/*.mp4 renders/reel/*.mp4; do
  d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
  if [ -z "$d" ]; then echo "BROKEN $f"; bad=1; else echo "ok $(basename $f) ${d}s"; fi
done
echo "RENDER-ALL FINISHED, broken files: $bad"
