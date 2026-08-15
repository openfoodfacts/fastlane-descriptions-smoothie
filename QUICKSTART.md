# Quick Start Guide: Changelog Translation Workflow

## For Maintainers

### Step 1: Update the English Changelog

Edit one of these files:

**Android:**
```bash
vim fastlane/metadata/android/en-US/default_changelog.txt
```

**iOS:**
```bash
vim fastlane/metadata/ios/en-US/default_release_notes.txt
```

### Step 2: Trigger Translation in Crowdin

```bash
git add fastlane/metadata/
git commit -m "Update changelog for version X.Y.Z"
git push origin main

# Then trigger Crowdin sync
git checkout crowdin-trigger
git merge main
git push origin crowdin-trigger
```

This will:
- Upload your English changelog to Crowdin
- Trigger automatic translation
- Create a PR with all translations

### Step 3: Sync Changelogs to Fastlane

After merging the Crowdin PR:

**Option A: GitHub Actions (Recommended)**
1. Go to: https://github.com/openfoodfacts/fastlane-descriptions-smoothie/actions/workflows/sync-changelogs.yml
2. Click "Run workflow"
3. Enter Android version code (e.g., `1044`)
4. Click "Run workflow"
5. Review and merge the generated PR

**Option B: Manual Script**
```bash
./sync-changelogs.sh 1044
git add .
git commit -m "Sync changelogs for version 1044"
git push
```

### Step 4: Deploy to Stores

**Android Play Store:**
```bash
git checkout upload-to-playstore
git merge main
git push origin upload-to-playstore
```

**iOS App Store:**
```bash
git checkout upload-to-appstore
git merge main
git push origin upload-to-appstore
```

## Example Workflow

```bash
# 1. Update changelog
echo "New feature: Added dark mode support" > fastlane/metadata/android/en-US/default_changelog.txt
git add fastlane/metadata/android/en-US/default_changelog.txt
git commit -m "Add dark mode changelog"
git push origin main

# 2. Trigger Crowdin translation
git checkout crowdin-trigger
git merge main
git push origin crowdin-trigger
# Wait for Crowdin PR and merge it

# 3. Sync to fastlane (via GitHub Actions)
# Click "Run workflow" with version code: 1045

# 4. After PR is merged, deploy
git checkout upload-to-playstore
git merge main
git push origin upload-to-playstore
```

## Files Created by This PR

- `fastlane/metadata/android/en-US/default_changelog.txt` - English source for Android
- `fastlane/metadata/ios/en-US/default_release_notes.txt` - English source for iOS
- `sync-changelogs.sh` - Script to sync translated files
- `.github/workflows/sync-changelogs.yml` - Automation workflow
- Updated `crowdin.yml` - Translation configuration

## Benefits

✅ Write changelog once in English
✅ Automatic translation to 185+ languages (Android) and 157+ languages (iOS)
✅ Consistent changelogs across all locales
✅ Simple workflow with GitHub Actions
✅ Version-controlled translation history
