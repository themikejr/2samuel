#!/bin/bash
# Remove background/historical characters that aren't part of 2 Samuel's narrative

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"

echo "Removing background characters..."
echo ""

# Characters to remove:
# - Patriarchs/tribal founders mentioned only historically
# - Book references (Jashar = Book of Jashar)
# - Generic groupings (Jerusalem Wives)

BACKGROUND_CHARS=(
  "israel.json"          # Jacob the patriarch
  "judah-4.json"         # Judah the patriarch/tribe founder
  "benjamin.json"        # Benjamin the patriarch/tribe founder
  "asher.json"           # Asher the patriarch/tribe founder
  "ephraim.json"         # Ephraim the patriarch/tribe founder
  "jashar.json"          # Book of Jashar, not a person
  "jerusalemwives.json"  # Generic collective, not an individual
  "abigal.json"          # Duplicate of abigail-2.json (spelling variant)
  "eliam.json"           # Duplicate of eliam-2.json (same person, different verses)
)

for char in "${BACKGROUND_CHARS[@]}"; do
  file="$CHARACTERS_DIR/$char"
  if [ -f "$file" ]; then
    name=$(jq -r '.name' "$file")
    echo "🗑️  Removing: $name ($char)"
    rm "$file"
  fi
done

echo ""
echo "✨ Background characters removed!"
echo ""
echo "Remaining characters:"
ls -1 "$CHARACTERS_DIR" | wc -l | xargs echo ""
