import 'dart:io';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

/// A simple check if a script is up to date with the pub version
class PubUpdateChecker {
  PubUpdateChecker._();

  static final _client = PubClient();

  /// Check if the current script is up to date with the pub version
  ///
  /// If the script is not up to date, this returns the latest version on pub
  ///
  /// [relativePubspecPath] is the path to the pubspec file relative to the
  /// script file
  static Future<Version?> check({
    String relativePubspecPath = '../pubspec.yaml',
  }) async {
    final pubspecPath =
        Platform.script.resolve(relativePubspecPath).toFilePath();
    final pubspec = await PubSpec.loadFile(pubspecPath);

    final name = pubspec.name;
    final version = pubspec.version;
    if (name == null || version == null) return null;

    final PubPackage pubPackage;
    try {
      pubPackage = await _client.packageInfo(name);
    } catch (e) {
      // Will throw if the package is not found
      return null;
    }

    final pubPackageVersion = Version.parse(pubPackage.version);
    final updateAvailable = pubPackageVersion.compareTo(version) > 0;

    return updateAvailable ? pubPackageVersion : null;
  }
}
