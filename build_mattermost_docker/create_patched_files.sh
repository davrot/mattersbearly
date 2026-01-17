#!/bin/bash

SOURCE_TAR="mattermost_source.tar.gz"
PATCH_DIR="./patches"
OUTPUT_DIR="./enterprise_replace"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Step 1: Identifying target files..."
# Get all relative paths from the patch filenames
mapfile -t TARGET_FILES < <(ls "$PATCH_DIR"/*.patch | xargs -n1 basename | sed 's/\.patch$//' | sed 's/_/\//g')

echo "Step 2: Extracting and Patching..."
for rel_path in "${TARGET_FILES[@]}"; do
    patch_file="$PATCH_DIR/$(echo "$rel_path" | sed 's/\//_/g').patch"
    
    # Ensure the target directory exists in our output folder
    mkdir -p "$(dirname "$OUTPUT_DIR/$rel_path")"

    # Try to extract the file from the tarball
    # We use a wildcard to find the file regardless of the top-level folder name
    tar -xf "$SOURCE_TAR" --wildcards -O "*/$rel_path" > "$OUTPUT_DIR/$rel_path" 2>/dev/null

    if [ -s "$OUTPUT_DIR/$rel_path" ]; then
        echo "Extracted and Patching: $rel_path"
        patch -s -N "$OUTPUT_DIR/$rel_path" < "$patch_file"
    else
        # If the file couldn't be extracted, it's likely a NEW file
        echo "Creating New File: $rel_path"
        # We use the patch to create the file from scratch
        # Stripping any potential prefixes from the patch header
        sed -e 's|^--- \./tmp_original_source/|--- |' -e 's|^+++ \./changed_files/|+++ |' "$patch_file" | patch -p0 -d "$OUTPUT_DIR" > /dev/null
    fi
done

echo "---"
echo "Final Check: Count of files in $OUTPUT_DIR"
find "$OUTPUT_DIR" -type f | wc -l
echo "---"
