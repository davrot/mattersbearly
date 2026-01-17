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
    "*/server/cmd/mattermost/main.go" \
    "*/server/channels/api4/oauth.go" \
    "*/server/channels/app/app.go" \
    "*/server/public/model/config.go" \
    "*/server/config/client.go" \
    "*/server/channels/app/server.go" \
    "*/webapp/channels/src/components/login/login.tsx" \
    "*/webapp/channels/src/actions/views/login.ts" \
    "*/webapp/platform/client/src/client4.ts"

# 3. Apply the patches
echo "Applying patches..."

# Check if files exist before patching to avoid the "Can't reopen" error
if [ -f "$OUTPUT_DIR/server/Makefile" ]; then
    patch "$OUTPUT_DIR/server/Makefile" < "$PATCH_DIR/server_makefile.patch"
    patch "$OUTPUT_DIR/server/cmd/mmctl/commands/compliance_export.go" < "$PATCH_DIR/compliance_export.patch"
    patch "$OUTPUT_DIR/server/cmd/mattermost/main.go" < "$PATCH_DIR/main_go.patch"
    patch "$OUTPUT_DIR/server/channels/api4/oauth.go" < "$PATCH_DIR/oidc_api4_oauth.patch"
    patch "$OUTPUT_DIR/server/channels/app/oidc.go" < "$PATCH_DIR/oidc_app_logic.patch"
    patch "$OUTPUT_DIR/server/channels/app/app.go" < "$PATCH_DIR/oidc_app_struct.patch"
    patch "$OUTPUT_DIR/server/public/model/config.go" < "$PATCH_DIR/oidc_model_config.patch"
    patch "$OUTPUT_DIR/server/public/model/oidc.go" < "$PATCH_DIR/oidc_model_struct.patch"
    patch "$OUTPUT_DIR/server/einterfaces/oidc.go" < "$PATCH_DIR/oidc_einterfaces.patch"
    patch "$OUTPUT_DIR/server/config/client.go" < "$PATCH_DIR/oidc_server_config.patch"
    patch "$OUTPUT_DIR/server/channels/app/server.go" < "$PATCH_DIR/oidc_app_server.patch"
    patch "$OUTPUT_DIR/webapp/channels/src/components/login/login.tsx" < "$PATCH_DIR/oidc_webapp_login_ui.patch"
    patch "$OUTPUT_DIR/webapp/channels/src/actions/views/login.ts" < "$PATCH_DIR/oidc_webapp_login_action.patch"
    patch "$OUTPUT_DIR/webapp/platform/client/src/client4.ts" < "$PATCH_DIR/oidc_webapp_client.patch"

    echo "Done! Modified files are ready in $OUTPUT_DIR"
else
    echo "Error: Files were not extracted correctly. Check the tarball content."
    exit 1
fi
