import 'package:pub_update_checker/pub_update_checker.dart';

void main() async {
  final newVersion = await PubUpdateChecker.check();
  if (newVersion != null) {
    print('There is an update available: $newVersion');
  } else {
    print('No update available');
  }
}
