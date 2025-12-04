#!/bin/bash
# Add family members of characters who have 2 Samuel references
# This ensures all familial listings are complete even if family members
# don't appear directly in 2 Samuel

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"
ACAI_DIR="$SCRIPT_DIR/../data/acai/people/json"

echo "Finding family members of existing characters..."
echo ""

# Collect all unique family member ACAI IDs from existing character files
family_ids=$(jq -r '
  [.father, .mother] + (.partners // []) + (.offspring // []) |
  .[] |
  select(. != null)
' "$CHARACTERS_DIR"/*.json 2>/dev/null | sort -u)

if [ -z "$family_ids" ]; then
  echo "No family member IDs found in existing character files"
  exit 0
fi

echo "Found $(echo "$family_ids" | wc -l | xargs) unique family member references"
echo ""

added_count=0
skipped_count=0

# Process each family member ID
for person_id in $family_ids; do
  # Extract filename from person ID (e.g., person:David -> david)
  filename=$(echo "$person_id" | sed 's/person://' | tr '[:upper:]' '[:lower:]' | sed 's/\./-/g')
  output_file="$CHARACTERS_DIR/${filename}.json"

  # Skip if file already exists
  if [ -f "$output_file" ]; then
    skipped_count=$((skipped_count + 1))
    continue
  fi

  # Find the source JSON file in ACAI
  source_file=$(grep -l "\"id\": \"$person_id\"" "$ACAI_DIR"/*.json | head -1)

  if [ -z "$source_file" ]; then
    echo "⚠️  Could not find source file for $person_id"
    continue
  fi

  # Extract relevant data and create character file
  # Note: We include ALL references (not just 2 Samuel) for complete Bible coverage
  jq '{
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

  echo "✅ Added $filename.json (family member)"
  added_count=$((added_count + 1))
done

echo ""
echo "Done! Added $added_count new family member(s)"
echo "Skipped $skipped_count character(s) that already existed"
