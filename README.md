<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://static.openfoodfacts.org/images/logos/off-logo-horizontal-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://static.openfoodfacts.org/images/logos/off-logo-horizontal-light.svg">
  <img height="100" src="https://static.openfoodfacts.org/images/logos/off-logo-horizontal-light.svg">
</picture>

# Automation of the Play Store and App Store listings for the new Open Food Facts mobile app (Smoothie) with Fastlane

See also the Mobile app main repository: https://github.com/openfoodfacts/smooth-app

### Metadata upload
- Once it works, the results should be visible on the stores for [Android](https://play.google.com/store/apps/details?id=org.openfoodfacts.scanner) and [iPhone/iPad](https://apps.apple.com/us/app/open-food-facts-product-scan/id588797948).
- We have to be careful to have better metadata than the current one, including texts and screenshots, and to bind this with Crowdin + a smart solution for asset translation (currently done in Figma)

### Screenshot wrapping (deprecated)
Screenshot wrapping adds texts and wrapping to raw screenshots. It currently does that automatically, and uploads as artefact

### Vignette improvement and translations
- https://docs.google.com/document/d/1XzGcftPHQ26A2by70yIgBriOnafYYcdSARQsFr0rb6o/edit#
- [Figma file](https://www.figma.com/design/loMFSX1wJ61jjuZkSeLV7e/Vignettes-App-Design--Quentin-?node-id=4318-83343&p=f&t=KgIuPEGmvH6ytGli-0)

### Translations
You'll be able to translate the PlayStore, App Store description and screenshot slogans at https://translate.openfoodfacts.org

### Changelog Management

This repository supports automated translation and deployment of changelogs for all supported languages.

#### How to update changelogs

1. **Edit the source changelog files** in English:
   - **Android**: Edit `fastlane/metadata/android/en-US/default_changelog.txt`
   - **iOS**: Edit `fastlane/metadata/ios/en-US/default_release_notes.txt`

2. **Trigger translation sync** (Manual method):
   - Push changes to the `crowdin-trigger` branch
   - Wait for Crowdin to sync translations
   - Review and merge the generated PR from the l10n_main branch

3. **Sync changelogs to fastlane directories** (Automated via GitHub Actions):
   - Go to Actions tab → "Sync Translated Changelogs" workflow
   - Click "Run workflow"
   - Enter the Android version code (e.g., 1044)
   - The workflow will:
     - Download latest translations from Crowdin
     - Copy translated changelogs to appropriate fastlane metadata directories
     - Create a PR with all the changes
   - Review and merge the PR

4. **Deploy changelogs to stores**:
   - For Android: Merge the PR to `upload-to-playstore` branch to trigger Play Store upload
   - For iOS: Merge the PR to `upload-to-appstore` branch to trigger App Store upload

#### Manual sync (alternative)

You can also manually sync changelogs using the provided script:

```bash
./sync-changelogs.sh <version_code>
```

Example:
```bash
./sync-changelogs.sh 1044
```

This will copy:
- `fastlane/metadata/android/<locale>/default_changelog.txt` → `fastlane/android/metadata/<locale>/changelogs/<version_code>.txt`
- `fastlane/metadata/ios/<locale>/default_release_notes.txt` → `fastlane/ios/fastlane/metadata/<locale>/release_notes.txt`
