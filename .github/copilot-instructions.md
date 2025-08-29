# Open Food Facts Fastlane Descriptions Automation

This repository automates Play Store and App Store listings for the Open Food Facts mobile app (Smoothie) using Fastlane. The project manages metadata, descriptions, and screenshots for 185+ Android locales and 157+ iOS locales.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Bootstrap Environment and Dependencies
- Install Ruby bundler: `sudo gem install bundler`
- **Android Setup:**
  - `cd fastlane/android && sudo bundle install` -- takes 5-15 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
- **iOS Setup:**
  - `cd fastlane/ios/fastlane && bundle install` -- takes 5-15 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
- **Screenshot Wrapping Setup (deprecated but functional):**
  - `cd screenshot-wrapping && PUPPETEER_SKIP_DOWNLOAD=true npm ci` -- takes 5-10 seconds due to network restrictions
  - Note: Puppeteer Chrome download will fail due to network limitations; use PUPPETEER_SKIP_DOWNLOAD=true

### Key Commands and Expected Times
- **Metadata validation:** `time docker run --rm -v "$PWD:/workspace" ashutoshgngwr/validate-fastlane-supply-metadata:v2 -fastlane-path /workspace/fastlane/android/metadata -play-store-locales` -- takes 15-20 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
- **Bundle operations:** 5-15 seconds each. NEVER CANCEL. Set timeout to 60+ seconds.
- **File counting operations:** Instant (< 1 second)

### Directory Structure Note
- Fastlane expects configuration in `fastlane/` subdirectory, but this repo stores configs directly in platform directories
- **DO NOT** create temporary fastlane/ subdirectories in the platform folders during testing as they will be committed accidentally

## Fastlane Operations

### Android Lanes (cd fastlane/android && bundle exec fastlane [lane])
- **deploy_marketing**: Deploy marketing metadata to Play Store (metadata, images, screenshots)
- **deploy_changelogs**: Deploy changelog updates only
- **Note**: Cannot test lanes without Google Play credentials - they will fail with authentication errors

### iOS Lanes (cd fastlane/ios/fastlane && bundle exec fastlane [lane])  
- **run_precheck**: Precheck metadata for Apple compliance
- **metadata**: Push description and meta info to App Store
- **beta**: Send metadata to TestFlight
- **setVersion**: Version management
- **Note**: Cannot test lanes without Apple credentials - they will fail with authentication errors

## Validation

### Always Run Metadata Validation Before Changes
- **Android validation**: `docker run --rm -v "$PWD:/workspace" ashutoshgngwr/validate-fastlane-supply-metadata:v2 -fastlane-path /workspace/fastlane/android/metadata -play-store-locales`
- **Expected issues**: Many locales are not recognized by Google Play (118+ errors is normal)
- **Critical issues to watch**: Content length violations (>4000 chars for full_description, >80 chars for short_description)
- **Image issues**: featureGraphic.png must be opaque (no alpha channel)

### Key Metadata Statistics
- **Android locales**: 185 directories in `fastlane/android/metadata/`
- **iOS locales**: 157 directories in `fastlane/ios/fastlane/metadata/`
- **Total Android metadata files**: 935+ `.txt` files
- **Critical files per locale**: `full_description.txt`, `short_description.txt`, `title.txt`

### Manual Validation Scenarios
- **Check metadata file counts**: `find fastlane/android/metadata -name "*.txt" | wc -l` (should return ~935)
- **Check locale count**: `ls fastlane/android/metadata | wc -l` (should return 185)
- **Sample content check**: `find fastlane/android/metadata -name "full_description.txt" | head -5 | xargs wc -l`
- **Always verify no accidental commits**: Check `.gitignore` contains `node_modules/` and avoid committing temporary fastlane/ subdirectories

## Common Tasks

### Repository Structure Overview
```
├── fastlane/
│   ├── android/          # Android Play Store automation
│   │   ├── Fastfile      # Lane definitions
│   │   ├── Appfile       # App configuration
│   │   ├── Gemfile       # Ruby dependencies
│   │   └── metadata/     # 185 locale directories
│   └── ios/
│       └── fastlane/     # iOS App Store automation
│           ├── Fastfile  # Lane definitions  
│           ├── Appfile   # App configuration
│           ├── Gemfile   # Ruby dependencies
│           └── metadata/ # 157 locale directories
├── screenshot-wrapping/  # Node.js screenshot tool (deprecated)
├── crowdin.yml          # Translation configuration
└── .github/workflows/   # CI/CD automation
```

### Frequent File Operations
```bash
# Repository root
ls -la
# .github  .gitignore  README.md  VIGNETTES.md  crowdin.yml  fastlane  featureGraphic.png  icon.png  icon.svg  screenshot-wrapping

# Sample metadata structure  
ls fastlane/android/metadata/en-US/
# changelogs  full_description.txt  images  short_description.txt  title.txt  video.txt
```

### Translation Management
- **Crowdin integration**: `crowdin.yml` manages 70+ translation mappings
- **Translation web interface**: https://translate.openfoodfacts.org
- **String files**: `screenshot-wrapping/strings/` contains JSON translation files

## Troubleshooting

### Common Permission Issues
- **Ruby gem installations**: Use `sudo gem install bundler` for global installation
- **Bundle install failures**: Run `sudo bundle install` if permission errors occur
- **Git repository**: File permissions should be preserved

### Network and Download Issues  
- **Puppeteer downloads**: Network restrictions require `PUPPETEER_SKIP_DOWNLOAD=true`
- **Git source dependencies**: May fail due to permission issues in `/var/lib/gems/`
- **Docker image downloads**: First run will download validation images (~1MB)

### Build Failures
- **Bundle version conflicts**: Repository uses bundler 2.3.13, newer versions show warnings but work
- **Missing directories**: Don't create temporary fastlane/ subdirectories 
- **Locale validation**: 118+ locale errors is normal - focus on content length violations

## CI/CD Integration

### GitHub Actions Workflows
- **check-android.yml**: Android metadata validation (every push)
- **check-ios.yml**: iOS metadata precheck (macOS runner)
- **validate-metadata.yml**: Comprehensive validation (main branch)
- **android-upload.yml** & **ios-upload.yml**: Store uploads (upload-to-playstore branch only)

### Environment Variables Required for Store Operations
- **Android**: `GOOGLE_PLAY_JSON_PATH`, `API_JSON_FILE_DECRYPTKEY`
- **iOS**: `FASTLANE_USER`, `SPACESHIP_CONNECT_API_*`, `MATCH_*` variables
- **Note**: Store upload operations require secret environment variables and cannot be tested locally

### Always Before Committing
- Run metadata validation to ensure no content length violations
- Check that node_modules/ is in .gitignore
- Verify no temporary fastlane/ directories are being committed
- Validate file permissions are preserved