#!/bin/bash
# Update all character files to include ALL Bible references (not just 2 Samuel)
# This reads from ACAI and updates the references field in existing character files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"
ACAI_DIR="$SCRIPT_DIR/../data/acai/people/json"

echo "Updating references in all character files..."
echo ""

updated_count=0
skipped_count=0
error_count=0

# Process each character file
for char_file in "$CHARACTERS_DIR"/*.json; do
  if [ ! -f "$char_file" ]; then
    continue
  fi

  # Get the ACAI ID from the character file
  acai_id=$(jq -r '.acaiId' "$char_file")

  if [ -z "$acai_id" ] || [ "$acai_id" = "null" ]; then
    echo "⚠️  No ACAI ID in $(basename "$char_file")"
    error_count=$((error_count + 1))
    continue
  fi

  # Find the source file in ACAI
  source_file=$(grep -l "\"id\": \"$acai_id\"" "$ACAI_DIR"/*.json | head -1)

  if [ -z "$source_file" ]; then
    echo "⚠️  Could not find ACAI source for $acai_id"
    error_count=$((error_count + 1))
    continue
  fi

  # Get all references from ACAI
  all_refs=$(jq -c '.references' "$source_file")

  # Check if references are different
  current_refs=$(jq -c '.references // []' "$char_file")

  if [ "$all_refs" = "$current_refs" ]; then
    skipped_count=$((skipped_count + 1))
    continue
  fi

  # Update the character file with all references
  jq --argjson refs "$all_refs" '.references = $refs' "$char_file" > "$char_file.tmp"
  mv "$char_file.tmp" "$char_file"

  echo "✅ Updated $(basename "$char_file")"
  updated_count=$((updated_count + 1))
done

echo ""
echo "Done!"
echo "  Updated: $updated_count"
echo "  Skipped (no change): $skipped_count"
echo "  Errors: $error_count"
