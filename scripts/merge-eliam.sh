#!/bin/bash
# Merge the two Eliam records into one canonical record
# This script ensures person:Eliam is the canonical ID, merging data from person:Eliam.2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"

echo "Merging Eliam records..."

# Create the merged eliam.json file
cat > "$CHARACTERS_DIR/eliam.json" << 'EOF'
{
  "acaiId": "person:Eliam",
  "name": "Eliam",
  "description": "Eliam, also known as Ammiel, was the son of Ahithophel and father of Bathsheba. He was one of David's mighty men.",
  "gender": "male",
  "father": "person:Ahithophel",
  "offspring": [
    "person:Bathsheba"
  ],
  "roles": [
    "Warrior"
  ],
  "references": [
    "10011003",
    "10023034",
    "13003005"
  ]
}
EOF

# Remove the duplicate eliam-2.json if it exists
if [ -f "$CHARACTERS_DIR/eliam-2.json" ]; then
  echo "Removing duplicate eliam-2.json"
  rm "$CHARACTERS_DIR/eliam-2.json"
fi

# Update references from person:Eliam.2 to person:Eliam in character files
echo "Updating references in character files..."
for file in "$CHARACTERS_DIR"/*.json; do
  if [ -f "$file" ]; then
    # Use sed to replace person:Eliam.2 with person:Eliam
    sed -i '' 's/"person:Eliam\.2"/"person:Eliam"/g' "$file"
  fi
done

echo "✨ Eliam records merged successfully!"
echo "   - Canonical ID: person:Eliam"
echo "   - Removed: eliam-2.json"
echo "   - Updated all references to use person:Eliam"
