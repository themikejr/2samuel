#!/bin/bash
# Create character JSON files from ACAI data for a given chapter
# Usage: ./create-character-files.sh <chapter_number>
# Example: ./create-character-files.sh 2

if [ -z "$1" ]; then
  echo "Usage: $0 <chapter_number>"
  echo "Example: $0 2"
  exit 1
fi

CHAPTER=$1
BOOK="10"
CHAPTER_PADDED=$(printf "%03d" "$CHAPTER")
PATTERN="${BOOK}${CHAPTER_PADDED}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"
ACAI_DIR="$SCRIPT_DIR/../data/acai/people/json"

echo "Finding characters in 2 Samuel Chapter $CHAPTER..."
echo ""

# Create characters directory if it doesn't exist
mkdir -p "$CHARACTERS_DIR"

# Find all people mentioned in this chapter
people=$(jq -r --arg pattern "$PATTERN" '
  select(.references != null) |
  select(.references | map(select(startswith($pattern))) | length > 0) |
  .id
' "$ACAI_DIR"/*.json)

if [ -z "$people" ]; then
  echo "No characters found in Chapter $CHAPTER"
  exit 0
fi

echo "Found the following characters:"
echo "$people" | sed 's/person:/  - /' | sort
echo ""

# Process each person
for person_id in $people; do
  # Extract filename from person ID (e.g., person:David -> david)
  filename=$(echo "$person_id" | sed 's/person://' | tr '[:upper:]' '[:lower:]' | sed 's/\./-/g')
  output_file="$CHARACTERS_DIR/${filename}.json"

  # Skip if file already exists
  if [ -f "$output_file" ]; then
    echo "⏭️  Skipping $person_id (already exists: $filename.json)"
    continue
  fi

  # Find the source JSON file
  source_file=$(grep -l "\"id\": \"$person_id\"" "$ACAI_DIR"/*.json | head -1)

  if [ -z "$source_file" ]; then
    echo "⚠️  Could not find source file for $person_id"
    continue
  fi

  # Extract relevant data and create character file
  jq --arg pattern "$PATTERN" '{
    acaiId: .id,
    name: .localizations.eng.preferred_label,
    description: (.localizations.eng.descriptions[0].description // "No description available"),
    gender: .gender,
    father: .father,
    mother: .mother,
    partners: .partners,
    offspring: .offspring,
    tribe: .tribe,
    roles: .roles,
    references: .references
  } |
  # Remove null values
  with_entries(select(.value != null))
  ' "$source_file" > "$output_file"

  echo "✅ Created $filename.json"
done

echo ""
echo "Done! Character files created in $CHARACTERS_DIR"
echo ""
echo "Note: This script includes ALL 2 Samuel references (not just Chapter $CHAPTER)."
echo "Review the generated files to ensure they represent individual characters."
