# Release Process

## Bump the version

* Go to `Lightning > Build Settings > CURRENT_PROJECT_VERSION`.
* Bump the version.

## Prapare Carthage Release

* Create a tag for the version and push it.

## Prepare Cocoapods Release

* Open `Lightning.podspec`.
* Update `s.version` field with the current version.
* Check other fields just in case there are any updates.
* Run: `pod spec lint Lightning.podspec`
* Run: `pod trunk push Lightning.podspec`
