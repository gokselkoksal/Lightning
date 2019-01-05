# Release Process

## Upgrade project version

* Go to `Lightning > Build Settings > CURRENT_PROJECT_VERSION`.
* Bump up the version.

## Upgrade pod version

* Open Lightning.podspec.
* Bump up the version using `s.version` field.

## Release the pod

* Run: `pod spec lint Lightning.podspec`
* Run: `pod trunk push Lightning.podspec`
