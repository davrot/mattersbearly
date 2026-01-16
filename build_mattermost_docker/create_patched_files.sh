#!/bin/bash

# Configuration
SOURCE_TAR="mattermost_source.tar.gz"
PATCH_DIR="./patches"
OUTPUT_DIR="./enterprise_replace"

# 1. Clean up and create base output dir
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# 2. Extract original files from tarball 
echo "Extracting source files..."
# We use --wildcards to fix the error you saw
# We use --strip-components=1 to remove the versioned top-level folder
tar -xf "$SOURCE_TAR" --wildcards --strip-components=1 -C "$OUTPUT_DIR" \
    "*/server/Makefile" \
    "*/server/cmd/mmctl/commands/compliance_export.go" \
    "*/server/cmd/mattermost/main.go"

# 3. Apply the patches
echo "Applying patches..."

# Check if files exist before patching to avoid the "Can't reopen" error
if [ -f "$OUTPUT_DIR/server/Makefile" ]; then
    patch "$OUTPUT_DIR/server/Makefile" < "$PATCH_DIR/server_makefile.patch"
    patch "$OUTPUT_DIR/server/cmd/mmctl/commands/compliance_export.go" < "$PATCH_DIR/compliance_export.patch"
    patch "$OUTPUT_DIR/server/cmd/mattermost/main.go" < "$PATCH_DIR/main_go.patch"
    echo "Done! Modified files are ready in $OUTPUT_DIR"
else
    echo "Error: Files were not extracted correctly. Check the tarball content."
    exit 1
fi
