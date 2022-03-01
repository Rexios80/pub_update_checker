Check if your dart script package is up to date in one line.

## Features

- One line check
- Handles getting the current version of the package
- Returns the pub version if an update is available

## Getting started

Have a dart script package published on pub.dev. This only works for a currently running globally activated package. Running in any other configuration will always show that the package is up to date.

## Usage

<!-- embedme example/example.dart -->
```dart
import 'package:pub_update_checker/pub_update_checker.dart';

void main() async {
  final newVersion = await PubUpdateChecker.check('your_package_name');
  if (newVersion != null) {
    print('There is an update available: $newVersion');
  } else {
    print('No update available');
  }
}

```
