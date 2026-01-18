#!/bin/bash

# Ensure variables are set
OUTPUT_DIR="${OUTPUT_DIR:-./enterprise_replace}"
PATCH_DIR="${PATCH_DIR:-./patches}"
SOURCE_TAR="${SOURCE_TAR:-./mattermost_source.tar.gz}"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Step 1: Processing patches..."

for patch_path in "$PATCH_DIR"/*.patch; do
    [ -e "$patch_path" ] || continue
    
    # 1. Extract raw path from +++ line
    # 2. Strip prefix (./changed_files/ or changed_files/)
    # 3. Clean up leading dots/slashes and trailing timestamps
    rel_path=$(grep -m 1 "^+++ " "$patch_path" | sed -E 's|^\+\+\+ ||' | sed -E 's|^(\./)?changed_files/||' | awk '{print $1}')

    if [ -z "$rel_path" ]; then
        echo "❌ Error: Could not determine path in $(basename "$patch_path")"
        continue
    fi

    target_dest="$OUTPUT_DIR/$rel_path"
    mkdir -p "$(dirname "$target_dest")"

    # Try to extract from tarball. 
    # Using "*$rel_path" helps if the tarball has a nested root folder like 'mattermost-7.1/'
    tar -xf "$SOURCE_TAR" --wildcards -O "*$rel_path" > "$target_dest" 2>/dev/null

    if [ -s "$target_dest" ]; then
        echo "✅ Patched: $rel_path"
        patch -s -N "$target_dest" < "$patch_path"
    else
        # Fix: Use -- to tell grep the pattern isn't an option
        if grep -q -- "--- /dev/null" "$patch_path"; then
            echo "🆕 New File: $rel_path"
        else
            echo "⚠️  Warning: $rel_path not found in tarball. Creating from patch anyway."
        fi
        
        # Standardize headers for the patch command to work reliably
        sed -e "s|^--- .*|--- a/$rel_path|" -e "s|^+++ .*|+++ b/$rel_path|" "$patch_path" | \
        patch -p1 -d "$OUTPUT_DIR" > /dev/null
    fi
done

echo "---"
echo "Final Check: Count of files in $OUTPUT_DIR"
find "$OUTPUT_DIR" -type f -not -empty | wc -l
echo "---"