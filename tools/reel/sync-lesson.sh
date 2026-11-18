#!/usr/bin/env bash
# Copies the lesson drawing code into Remotion's public folder (run before studio/render; render-lessons.sh does it).
cd "$(dirname "$0")"; mkdir -p public/lesson
cp ../studio/lib.js ../studio/series.js ../studio/basics-core.js public/lesson/
