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

### App Privacy Details
- App privacy details are automatically uploaded to the Apple App Store using the `upload_privacy` lane
- The privacy configuration is stored in `fastlane/ios/fastlane/app_privacy_details.json`
- Current privacy configuration:
  - Privacy Policy URL: https://world.openfoodfacts.org/terms-of-use
  - Data collected (not linked to user):
    - **Diagnostics**: Crash Data (for App Functionality)
    - **Usage Data**: Product Interaction (for Analytics and App Functionality)
- For more information, see the [Fastlane documentation](https://docs.fastlane.tools/uploading-app-privacy-details/)

### Screenshot wrapping (deprecated)
Screenshot wrapping adds texts and wrapping to raw screenshots. It currently does that automatically, and uploads as artefact

### Vignette improvement and translations
- https://docs.google.com/document/d/1XzGcftPHQ26A2by70yIgBriOnafYYcdSARQsFr0rb6o/edit#
- [Figma file](https://www.figma.com/design/loMFSX1wJ61jjuZkSeLV7e/Vignettes-App-Design--Quentin-?node-id=4318-83343&p=f&t=KgIuPEGmvH6ytGli-0)

### Translations
You'll be able to translate the PlayStore, App Store description and screenshot slogans at https://translate.openfoodfacts.org
