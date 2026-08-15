# Changelog Translation and Deployment Workflow

This document describes the automated workflow for managing changelogs in all languages.

## Overview

The changelog translation system allows maintainers to write changelogs once in English, which are then automatically translated to all supported languages and deployed to both Android Play Store and iOS App Store.

## Architecture

```
Source Files (English)
├── fastlane/metadata/android/en-US/default_changelog.txt
└── fastlane/metadata/ios/en-US/default_release_notes.txt
         ↓
    Crowdin Translation
         ↓
Translated Files (All Languages)
├── fastlane/metadata/android/<locale>/default_changelog.txt
└── fastlane/metadata/ios/<locale>/default_release_notes.txt
         ↓
    sync-changelogs.sh script
         ↓
Fastlane Metadata Directories
├── fastlane/android/metadata/<locale>/changelogs/<version>.txt
└── fastlane/ios/fastlane/metadata/<locale>/release_notes.txt
         ↓
   Upload to Stores (via Fastlane)
```

## Usage Workflow

### Step 1: Update Source Changelogs

Edit the English source files:

**For Android:**
```bash
vim fastlane/metadata/android/en-US/default_changelog.txt
```

**For iOS:**
```bash
vim fastlane/metadata/ios/en-US/default_release_notes.txt
```

### Step 2: Trigger Crowdin Translation

Push changes to the `crowdin-trigger` branch:

```bash
git checkout crowdin-trigger
git merge main  # or your working branch
git push origin crowdin-trigger
```

This triggers the Crowdin sync workflow which:
1. Uploads source files to Crowdin
2. Downloads translated files
3. Creates a PR with translations to merge back to main

### Step 3: Sync to Fastlane Directories

Once translations are merged, use the GitHub Actions workflow:

1. Go to **Actions** tab in GitHub
2. Select **"Sync Translated Changelogs"** workflow
3. Click **"Run workflow"**
4. Enter the Android version code (e.g., `1044`)
5. Click **"Run workflow"**

The workflow will:
- Download latest translations from Crowdin (optional)
- Copy changelogs to appropriate fastlane directories
- Create a PR with all synced files

Alternatively, run the script manually:

```bash
./sync-changelogs.sh 1044
git add .
git commit -m "Update changelogs for version 1044"
git push
```

### Step 4: Deploy to Stores

After reviewing and merging the changelog PR:

**For Android Play Store:**
```bash
git checkout upload-to-playstore
git merge main
git push origin upload-to-playstore
```

**For iOS App Store:**
```bash
git checkout upload-to-appstore
git merge main
git push origin upload-to-appstore
```

## Supported Languages

- **Android:** 185+ locales
- **iOS:** 157+ locales

All languages configured in Crowdin will automatically receive translated changelogs.

## Files Structure

### Source Files (for translation)
```
fastlane/metadata/
├── android/
│   └── en-US/
│       └── default_changelog.txt
└── ios/
    └── en-US/
        └── default_release_notes.txt
```

### Translated Files (from Crowdin)
```
fastlane/metadata/
├── android/
│   ├── en-US/default_changelog.txt
│   ├── fr-FR/default_changelog.txt
│   ├── es-ES/default_changelog.txt
│   └── ... (all locales)
└── ios/
    ├── en-US/default_release_notes.txt
    ├── fr-FR/default_release_notes.txt
    └── ... (all locales)
```

### Fastlane Metadata (for store upload)
```
fastlane/
├── android/metadata/
│   └── <locale>/
│       └── changelogs/
│           ├── 1043.txt
│           ├── 1044.txt
│           └── <version>.txt
└── ios/fastlane/metadata/
    └── <locale>/
        └── release_notes.txt
```

## Key Configuration Files

- **crowdin.yml**: Defines translation mappings for Crowdin
- **sync-changelogs.sh**: Script to copy translated files to fastlane directories
- **.github/workflows/sync-changelogs.yml**: Automated workflow for syncing
- **.github/workflows/crowdin.yml**: Crowdin integration workflow

## Troubleshooting

### Translations not appearing in Crowdin

1. Check that source files exist in `fastlane/metadata/<platform>/en-US/`
2. Verify crowdin.yml has correct file paths
3. Ensure crowdin-trigger branch workflow completed successfully

### Sync script not copying files

1. Verify source files exist in `fastlane/metadata/<platform>/<locale>/`
2. Check script permissions: `chmod +x sync-changelogs.sh`
3. Ensure locale directories exist in fastlane metadata directories

### Store upload failing

1. Check fastlane metadata validation
2. Verify changelog length limits (Play Store: 500 chars)
3. Check that version code exists in fastlane/android/metadata/<locale>/changelogs/
