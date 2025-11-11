# App Review Contact Information

This directory contains contact information that will be automatically submitted to Apple App Store Connect during app submissions via Fastlane.

## Files

- **first_name.txt**: First name of the contact person for app reviews
- **last_name.txt**: Last name of the contact person for app reviews  
- **phone_number.txt**: Phone number for Apple to contact during the review process
- **email_address.txt**: Email address for Apple to contact during the review process
- **notes.txt**: Optional notes for the app review team

## How it works

When running the `fastlane ios metadata` lane, Fastlane's `deliver` action automatically reads these files and submits the contact information to App Store Connect. This happens automatically - no code changes are needed in the Fastfile.

## Updating contact information

To update the contact information:

1. Edit the relevant `.txt` files in this directory
2. Commit and push the changes
3. The next time the metadata lane runs, the updated information will be submitted

## Important notes

- These files are at the root metadata level (not per-locale)
- All paths should be relative to the repository root
- The phone number should include the country code
- Demo account fields (demo_account_name.txt, demo_account_password.txt) can be added if the app requires a demo account for review

## Reference

For more information, see the [Fastlane deliver documentation](https://docs.fastlane.tools/actions/deliver/).
