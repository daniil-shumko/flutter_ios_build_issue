#!/bin/sh
set -eo pipefail

gpg --quiet --batch --yes --decrypt --passphrase="$IOS_GPG_KEY_PROV" --output ./.github/secrets/flutter.mobileprovision ./.github/secrets/flutter.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$IOS_GPG_KEY_P12" --output ./.github/secrets/Distribution.p12 ./.github/secrets/Distribution.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/flutter.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/flutter.mobileprovision


security create-keychain -p "" build.keychain
security import ./.github/secrets/Distribution.p12 -t agg -k ~/Library/Keychains/build.keychain -P "$IOS_P12_KEY" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain