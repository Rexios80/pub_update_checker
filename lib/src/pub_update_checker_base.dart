import 'dart:io';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

/// A simple check if a script is up to date with the pub version
class PubUpdateChecker {
  PubUpdateChecker._();

  static final _client = PubClient();

  /// Check if the current script is up to date with the pub version. Will only
  /// work if the script is globally activated.
  ///
  /// If the script is not up to date, this returns the latest version on pub
  ///
  /// [package] is the name of the package containing the script
  static Future<Version?> check(String package) async {
    final lockPath = Platform.script.resolve('../pubspec.lock').toFilePath();

    final String lockContent;
    try {
      lockContent = File(lockPath).readAsStringSync();
    } catch (e) {
      // Will fail if the file is not found
      // ex: The script file is nested more than once and not globally activated
      return null;
    }

    final lock = loadYaml(lockContent);
    final versionString = lock['packages']?[package]?['version'] as String?;

    if (versionString == null) {
      // This is not a globally activated package
      return null;
    }

    final version = Version.parse(versionString);

    final PubPackage pubPackage;
    try {
      pubPackage = await _client.packageInfo(package);
    } catch (e) {
      // Will throw if the package is not found
      return null;
    }

    final pubPackageVersion = Version.parse(pubPackage.version);
    final updateAvailable = pubPackageVersion.compareTo(version) > 0;

    return updateAvailable ? pubPackageVersion : null;
  }
}
