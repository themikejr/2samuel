#!/bin/bash
# Create character files for all chapters of 2 Samuel
# Usage: ./create-all-characters.sh [start_chapter] [end_chapter]
# Example: ./create-all-characters.sh 1 24

START_CHAPTER=${1:-1}
END_CHAPTER=${2:-24}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Processing 2 Samuel chapters $START_CHAPTER to $END_CHAPTER..."
echo ""

for chapter in $(seq $START_CHAPTER $END_CHAPTER); do
  echo "═══════════════════════════════════════════"
  echo "Processing Chapter $chapter"
  echo "═══════════════════════════════════════════"
  "$SCRIPT_DIR/create-character-files.sh" "$chapter"
  echo ""
done

echo "✨ All chapters processed!"
echo ""
echo "Summary:"
ls -1 "$SCRIPT_DIR/../src/content/characters/" | wc -l | xargs echo "Total character files:"
