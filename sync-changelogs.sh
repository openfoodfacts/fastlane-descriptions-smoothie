#!/bin/bash
# Script to sync translated changelogs to fastlane metadata directories
# Usage: ./sync-changelogs.sh <version_code>
#
# This script copies the translated default_changelog.txt files from 
# fastlane/metadata/android/<locale>/default_changelog.txt to 
# fastlane/android/metadata/<locale>/changelogs/<version_code>.txt
#
# For iOS, it copies from fastlane/metadata/ios/<locale>/default_release_notes.txt
# to fastlane/ios/fastlane/metadata/<locale>/release_notes.txt

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <version_code>"
    echo "Example: $0 1044"
    exit 1
fi

VERSION_CODE=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

echo "Syncing changelogs for Android version $VERSION_CODE..."

# Sync Android changelogs
ANDROID_SOURCE_DIR="$REPO_ROOT/fastlane/metadata/android"
ANDROID_DEST_DIR="$REPO_ROOT/fastlane/android/metadata"

if [ ! -d "$ANDROID_SOURCE_DIR" ]; then
    echo "Warning: Android source directory not found: $ANDROID_SOURCE_DIR"
    echo "Skipping Android changelog sync."
else
    # Find all translated default_changelog.txt files
    find "$ANDROID_SOURCE_DIR" -name "default_changelog.txt" | while read -r source_file; do
        # Extract locale from path
        locale=$(echo "$source_file" | sed -E "s|$ANDROID_SOURCE_DIR/([^/]+)/default_changelog.txt|\1|")
        
        # Create destination directory
        dest_dir="$ANDROID_DEST_DIR/$locale/changelogs"
        mkdir -p "$dest_dir"
        
        # Copy file
        dest_file="$dest_dir/$VERSION_CODE.txt"
        cp "$source_file" "$dest_file"
        echo "  Copied: $locale -> changelogs/$VERSION_CODE.txt"
    done
    echo "Android changelog sync complete!"
fi

echo ""
echo "Syncing release notes for iOS..."

# Sync iOS release notes
IOS_SOURCE_DIR="$REPO_ROOT/fastlane/metadata/ios"
IOS_DEST_DIR="$REPO_ROOT/fastlane/ios/fastlane/metadata"

if [ ! -d "$IOS_SOURCE_DIR" ]; then
    echo "Warning: iOS source directory not found: $IOS_SOURCE_DIR"
    echo "Skipping iOS release notes sync."
else
    # Find all translated default_release_notes.txt files
    find "$IOS_SOURCE_DIR" -name "default_release_notes.txt" | while read -r source_file; do
        # Extract locale from path
        locale=$(echo "$source_file" | sed -E "s|$IOS_SOURCE_DIR/([^/]+)/default_release_notes.txt|\1|")
        
        # Create destination directory
        dest_dir="$IOS_DEST_DIR/$locale"
        mkdir -p "$dest_dir"
        
        # Copy file
        dest_file="$dest_dir/release_notes.txt"
        cp "$source_file" "$dest_file"
        echo "  Copied: $locale -> release_notes.txt"
    done
    echo "iOS release notes sync complete!"
fi

echo ""
echo "All changelogs synced successfully!"
echo "Next steps:"
echo "  1. Review the changes: git status"
echo "  2. Commit the changes: git add . && git commit -m 'Update changelogs for version $VERSION_CODE'"
echo "  3. Push to trigger store uploads (if configured)"
