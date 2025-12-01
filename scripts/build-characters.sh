#!/bin/bash
# Master script to build and clean character database from ACAI data
# This orchestrates the entire character creation and cleanup process
#
# Usage: ./build-characters.sh [start_chapter] [end_chapter]
# Example: ./build-characters.sh 1 24
#
# Process:
# 1. Create character files from ACAI data
# 2. Clean character names (remove scripture disambiguations)
# 3. Fix known name collisions (e.g., Nathan)
# 4. Remove background/non-narrative characters
# 5. Report final status and any remaining issues

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
START_CHAPTER=${1:-1}
END_CHAPTER=${2:-24}

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  2 Samuel Character Database Builder                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Processing chapters $START_CHAPTER-$END_CHAPTER..."
echo ""

# Step 1: Create character files from ACAI
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Creating character files from ACAI data"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/create-all-characters.sh" "$START_CHAPTER" "$END_CHAPTER"
echo ""

# Step 2: Clean character names
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Cleaning character names"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/clean-character-names.sh"
echo ""

# Step 3: Fix known name collisions
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Fixing known name collisions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/fix-nathan-disambiguation.sh"
echo ""

# Step 4: Remove background characters
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 4: Removing background/non-narrative characters"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/remove-background-characters.sh"
echo ""

# Step 5: Final report
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 5: Final validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/check-name-collisions.sh"
echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  BUILD COMPLETE                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

CHARACTERS_DIR="$SCRIPT_DIR/../src/content/characters"
TOTAL_CHARS=$(ls -1 "$CHARACTERS_DIR"/*.json 2>/dev/null | wc -l | tr -d ' ')

echo "📊 Summary:"
echo "   • Total characters: $TOTAL_CHARS"
echo "   • Chapters processed: $START_CHAPTER-$END_CHAPTER"
echo "   • Character files: $CHARACTERS_DIR"
echo ""
echo "✅ Character database is ready!"
echo ""
echo "Next steps:"
echo "   • View characters: http://localhost:4321/characters"
echo "   • Start dev server: npm run dev"
echo ""
