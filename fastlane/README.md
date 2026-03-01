fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### tests

```sh
[bundle exec] fastlane tests
```



### lint

```sh
[bundle exec] fastlane lint
```



----


## iOS

### ios all_tests

```sh
[bundle exec] fastlane ios all_tests
```

Run tests

### ios all_coverage

```sh
[bundle exec] fastlane ios all_coverage
```

Run all tests with code coverage

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app for App Store

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and upload to App Store Connect

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Run snapshot tests and frame screenshots

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload screenshots to App Store Connect

### ios upload_metadata

```sh
[bundle exec] fastlane ios upload_metadata
```

Upload metadata only to App Store Connect

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
