# Character Database Scripts

This directory contains scripts to build and maintain the 2 Samuel character database from ACAI data.

## Quick Start

To rebuild the entire character database from scratch:

```bash
# Remove existing characters
rm -rf ../src/content/characters/*.json

# Build all characters for all 24 chapters
./build-characters.sh 1 24
```

## Master Script

### `build-characters.sh`
**Master orchestration script that runs the entire pipeline.**

```bash
./build-characters.sh [start_chapter] [end_chapter]
```

**What it does:**
1. Creates character files from ACAI data
2. Cleans character names (removes scripture disambiguations)
3. Fixes known name collisions (e.g., Nathan)
4. Removes background/non-narrative characters
5. Validates and reports any issues

**Examples:**
```bash
# Build all chapters
./build-characters.sh 1 24

# Build specific range
./build-characters.sh 1 8

# Rebuild single chapter
./build-characters.sh 5 5
```

## Individual Scripts

### Data Extraction

#### `find-people-by-chapter.sh <chapter>`
Query ACAI dataset to find people mentioned in a specific chapter.

```bash
./find-people-by-chapter.sh 1
```

Returns JSON output with character details.

#### `create-character-files.sh <chapter>`
Create character JSON files for a specific chapter.

```bash
./create-character-files.sh 2
```

- Extracts data from ACAI
- Creates files in `src/content/characters/`
- Skips existing files
- Includes ALL 2 Samuel references (not just the queried chapter)

#### `create-all-characters.sh [start] [end]`
Bulk process multiple chapters.

```bash
./create-all-characters.sh 1 24
```

### Data Cleaning

#### `clean-character-names.sh`
Remove scripture reference disambiguations from names.

**Removes:**
- "(2 Samuel 5:16)"
- "(1 Samuel 9:2)"

**Keeps:**
- "(Son of Kish)"
- "(Prophet)"
- Other descriptive disambiguations

```bash
./clean-character-names.sh
```

#### `fix-nathan-disambiguation.sh`
Handle known name collisions.

Currently fixes:
- Nathan → Nathan (Son of David)
- Nathan → Nathan (Prophet)

```bash
./fix-nathan-disambiguation.sh
```

#### `remove-background-characters.sh`
Remove non-narrative characters from the database.

**Removes:**
- Patriarchs (Israel/Jacob, Judah, Benjamin, Asher, Ephraim)
- Book references (Jashar = Book of Jashar)
- Generic groupings (Jerusalem Wives)

These appear in ACAI because they're referenced in 2 Samuel text (e.g., "the tribe of Judah"), but aren't active narrative participants.

```bash
./remove-background-characters.sh
```

### Validation

#### `check-name-collisions.sh`
Report characters with identical base names.

```bash
./check-name-collisions.sh
```

Helps identify characters that need disambiguation.

## Data Flow

```
ACAI Dataset (data/acai/people/json/)
         ↓
[find-people-by-chapter.sh] ← Query by chapter
         ↓
[create-character-files.sh] ← Extract & create JSON
         ↓
[clean-character-names.sh] ← Remove scripture refs
         ↓
[fix-nathan-disambiguation.sh] ← Handle collisions
         ↓
[remove-background-characters.sh] ← Filter narrative chars
         ↓
[check-name-collisions.sh] ← Validate
         ↓
src/content/characters/ ← Final database
```

## Character File Format

Each character is stored as JSON in `src/content/characters/`:

```json
{
  "acaiId": "person:David",
  "name": "David",
  "description": "Second king of Israel...",
  "gender": "male",
  "father": "person:Jesse",
  "mother": "person:Nahash.3",
  "partners": ["person:Michal", ...],
  "offspring": ["person:Amnon", ...],
  "tribe": "group:Judah",
  "roles": ["Shepherd", "Warrior", "King"],
  "references": ["10001001", "10001002", ...]
}
```

## Adding New Chapters

When you write a new blog post for a chapter:

```bash
# Add characters from that chapter
./create-character-files.sh 9

# Or rebuild entire database
./build-characters.sh 1 24
```

## Troubleshooting

**Issue:** Script says "command not found"
```bash
chmod +x *.sh
```

**Issue:** Character names still have "(2 Samuel X:Y)"
```bash
./clean-character-names.sh
```

**Issue:** "Israel" linking incorrectly
```bash
./remove-background-characters.sh
```

**Issue:** Duplicate character names
```bash
./check-name-collisions.sh
# Then manually add disambiguation to affected files
```

## Reference Numbers

ACAI uses reference format: `BBCCCVVV`
- BB = Book number (10 = 2 Samuel)
- CCC = Chapter (001-024)
- VVV = Verse (001-999)

Example: `10005014` = 2 Samuel 5:14
