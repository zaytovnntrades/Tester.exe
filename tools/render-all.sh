#!/usr/bin/env bash
# Renders the 30 clean (silent, caption-free) lesson videos d01-d30, then checks every file.
# Run from the repo root: bash tools/render-all.sh            (all 30)
#                         bash tools/render-all.sh d04 d12    (just those)
# Re-time one video to your CapCut voice: node tools/studio/render.js tools/studio/basics.html renders/clean/d04-clean.mp4 "id=d04&clean&d=2.1,6.4,4.9,10.2,8.6,4.5"
set -u
cd "$(dirname "$0")/.."
mkdir -p renders/clean
ids="$*"; [ -z "$ids" ] && ids=$(node -e "console.log(require('./tools/studio/series.js').ORDER.join(' '))")
for id in $ids; do node tools/studio/render.js tools/studio/basics.html renders/clean/$id-clean.mp4 "id=$id&clean" 2>&1 | tail -1; done
bad=0
for id in $ids; do f=renders/clean/$id-clean.mp4
  d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
  if [ -z "$d" ]; then echo "BROKEN $f"; bad=1; else echo "ok $id ${d}s"; fi
done
echo "RENDER-ALL FINISHED, broken files: $bad"
