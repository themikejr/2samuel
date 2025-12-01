#!/bin/bash
# Check for characters with the same base name (potential collisions)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"

echo "Checking for name collisions..."
echo ""

# Create temp file with base names and full info
temp_file=$(mktemp)

for file in "$CHARACTERS_DIR"/*.json; do
  filename=$(basename "$file")
  full_name=$(jq -r '.name' "$file")

  # Extract base name (everything before first parenthesis or the full name)
  base_name=$(echo "$full_name" | sed 's/ *(.*//')

  echo "$base_name|$filename|$full_name" >> "$temp_file"
done

# Find duplicates
sort "$temp_file" | uniq -w 100 -D | while IFS='|' read -r base_name filename full_name; do
  # Count occurrences of this base name
  count=$(grep -c "^$base_name|" "$temp_file")

  if [ "$count" -gt 1 ]; then
    if ! grep -q "^REPORTED:$base_name$" "$temp_file.reported" 2>/dev/null; then
      echo "⚠️  '$base_name' appears $count times:"
      grep "^$base_name|" "$temp_file" | while IFS='|' read -r bn fn fna; do
        echo "   - $fn: $fna"
      done
      echo ""
      echo "REPORTED:$base_name" >> "$temp_file.reported"
    fi
  fi
done

# Cleanup
rm -f "$temp_file" "$temp_file.reported"

echo "✅ Check complete!"
