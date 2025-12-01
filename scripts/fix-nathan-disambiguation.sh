#!/bin/bash
# Fix Nathan name collision by adding proper disambiguation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"

echo "Fixing Nathan disambiguation..."
echo ""

# Nathan (Son of David) - nathan.json
if [ -f "$CHARACTERS_DIR/nathan.json" ]; then
  jq '.name = "Nathan (Son of David)"' "$CHARACTERS_DIR/nathan.json" > "$CHARACTERS_DIR/nathan.json.tmp"
  mv "$CHARACTERS_DIR/nathan.json.tmp" "$CHARACTERS_DIR/nathan.json"
  echo "✅ nathan.json → Nathan (Son of David)"
fi

# Nathan the Prophet - nathan-2.json
if [ -f "$CHARACTERS_DIR/nathan-2.json" ]; then
  jq '.name = "Nathan (Prophet)"' "$CHARACTERS_DIR/nathan-2.json" > "$CHARACTERS_DIR/nathan-2.json.tmp"
  mv "$CHARACTERS_DIR/nathan-2.json.tmp" "$CHARACTERS_DIR/nathan-2.json"
  echo "✅ nathan-2.json → Nathan (Prophet)"
fi

echo ""
echo "✨ Nathan disambiguation complete!"
