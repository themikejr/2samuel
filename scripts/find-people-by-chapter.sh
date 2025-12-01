#!/bin/bash
# Find people in ACAI dataset by 2 Samuel chapter reference
# Usage: ./find-people-by-chapter.sh <chapter_number>
# Example: ./find-people-by-chapter.sh 1

if [ -z "$1" ]; then
  echo "Usage: $0 <chapter_number>"
  echo "Example: $0 1"
  exit 1
fi

CHAPTER=$1
# 2 Samuel is book 10 in the numeric reference system
BOOK="10"
# Pad chapter to 3 digits (e.g., 1 -> 001)
CHAPTER_PADDED=$(printf "%03d" "$CHAPTER")
# The reference pattern to match (e.g., 10001 for 2 Samuel chapter 1)
PATTERN="${BOOK}${CHAPTER_PADDED}"

echo "Searching for people in 2 Samuel Chapter $CHAPTER (reference pattern: ${PATTERN}*)..."
echo ""

# Find all JSON files in the people directory that contain references matching our pattern
jq -r --arg pattern "$PATTERN" '
  select(.references != null) |
  select(.references | map(select(startswith($pattern))) | length > 0) |
  {
    id: .id,
    name: .localizations.eng.preferred_label,
    description: (.localizations.eng.descriptions[0].description // "No description"),
    father: .father,
    mother: .mother,
    partners: .partners,
    offspring: .offspring,
    tribe: .tribe,
    roles: .roles,
    gender: .gender,
    references: [.references[] | select(startswith($pattern))]
  }
' /Users/mtb/Projects/2samuel/data/acai/people/json/*.json
