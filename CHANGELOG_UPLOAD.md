# Changelog-Only Upload

This repository now supports uploading only changelogs/release notes to the app stores without uploading screenshots and other metadata.

## How to Use

### Android (Google Play Store)

To upload only changelogs to the Google Play Store, push to the `upload-changelogs-android` branch. This will trigger the GitHub workflow that:

1. Uses the existing `deploy_changelogs` fastlane lane
2. Uploads only the changelogs from `fastlane/android/metadata/{locale}/changelogs/{version}.txt`
3. Skips uploading metadata, images, and screenshots

### iOS (App Store)

To upload only release notes to the App Store, push to the `upload-changelogs-ios` branch. This will trigger the GitHub workflow that:

1. Uses the `upload_changelogs` fastlane lane
2. Uploads only the release notes from `fastlane/ios/fastlane/metadata/{locale}/release_notes.txt`
3. Skips uploading metadata and screenshots

## Manual Usage

You can also run the lanes manually using fastlane:

### Android
```bash
cd fastlane/android
bundle exec fastlane deploy_changelogs
```

### iOS
```bash
cd fastlane/ios/fastlane
bundle exec fastlane upload_changelogs
```

## Directory Structure

- **Android changelogs**: `fastlane/android/metadata/{locale}/changelogs/{version}.txt`
- **iOS release notes**: `fastlane/ios/fastlane/metadata/{locale}/release_notes.txt`

Where `{locale}` is the language code (e.g., `en-US`, `fr-FR`) and `{version}` is the version number for Android changelogs.