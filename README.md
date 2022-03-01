Check if your dart script package is up to date in one line. Uses the pubspec of the package to check the version.

## Features

- One line check
- Handles getting the current version of the package
- Returns the pub version if an update is available

## Getting started

Have a dart script package published on pub.dev

## Usage

<!-- embedme example/example.dart -->
```dart
import 'package:pub_update_checker/pub_update_checker.dart';

void main() async {
  final newVersion = await PubUpdateChecker.check();
  if (newVersion != null) {
    print('There is an update available: $newVersion');
  } else {
    print('No update available');
  }
}

```
