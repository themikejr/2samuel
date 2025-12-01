#!/bin/bash
# Clean and normalize character names from ACAI data
# Removes scripture reference disambiguations and handles name collisions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"

echo "Cleaning character names..."
echo ""

# Process each character file
for file in "$CHARACTERS_DIR"/*.json; do
  filename=$(basename "$file")

  # Extract current name
  current_name=$(jq -r '.name' "$file")

  # Remove scripture reference patterns like "(2 Samuel 5:16)", "(1 Samuel 9:2)", etc.
  # Keep other disambiguations like "(Son of Kish)"
  cleaned_name=$(echo "$current_name" | sed -E 's/ ?\([12] Samuel [0-9]+:[0-9]+\)//g')

  # Only update if the name changed
  if [ "$current_name" != "$cleaned_name" ]; then
    # Update the name in the JSON file
    jq --arg new_name "$cleaned_name" '.name = $new_name' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    echo "✅ $filename: '$current_name' → '$cleaned_name'"
  fi
done

echo ""
echo "✨ Name cleaning complete!"
echo ""
echo "Next steps:"
echo "1. Review the changes"
echo "2. Check for any duplicate base names"
echo "3. Run: ./check-name-collisions.sh"
