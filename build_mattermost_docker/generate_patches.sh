#!/bin/bash

# Define where your modified files are
MODIFIED_DIR="./changed_files"
# Define where the original source is extracted
ORIGINAL_DIR="./tmp_original_source"
PATCH_OUT="./patches"

# Ensure directories exist
mkdir -p "$PATCH_OUT"
mkdir -p "$ORIGINAL_DIR"

echo "Extracting original source for comparison..."
if [ -f "mattermost_source.tar.gz" ]; then
    tar -xf mattermost_source.tar.gz --strip-components=1 -C "$ORIGINAL_DIR"
else
    echo "Error: mattermost_source.tar.gz not found!"
    exit 1
fi

echo "Autodetecting modified files and generating patches..."
echo "---"

# Find all files in the MODIFIED_DIR
# We use -type f to get files only, and cut the prefix to get the relative path
find "$MODIFIED_DIR" -type f | while read -r full_path; do
    # Get the path relative to the MODIFIED_DIR (e.g., server/channels/app/app.go)
    rel_path=${full_path#$MODIFIED_DIR/}
    
    # Create a descriptive patch name (e.g., server_channels_app_app.patch)
    # 1. Replace slashes with underscores
    # 2. Remove leading dots or slashes
    # 3. Append .patch
    patch_name=$(echo "$rel_path" | sed 's/\//_/g').patch

    if [ -f "$ORIGINAL_DIR/$rel_path" ]; then
        echo "Processing: $rel_path"
        diff -uN "$ORIGINAL_DIR/$rel_path" "$full_path" > "$PATCH_OUT/$patch_name"
    else
        echo "New file detected (no original found): $rel_path"
        # This will create a patch that 'adds' the file from scratch
        diff -uN /dev/null "$full_path" > "$PATCH_OUT/$patch_name"
    fi
done

# Cleanup
rm -rf "$ORIGINAL_DIR"

echo "---"
echo "Done! All patches are located in: $PATCH_OUT"
ls -1 "$PATCH_OUT"
