import 'dart:io';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

/// A simple check if a script is up to date with the pub version
class PubUpdateChecker {
  PubUpdateChecker._();

  static final _client = PubClient();

  /// Check if the current script is up to date with the pub version. Will only
  /// work if the script is globally activated. Otherwise it will always return
  /// null.
  ///
  /// If the script is not up to date, this returns the latest version on pub
  static Future<Version?> check() async {
    final lockPath = Platform.script.resolve('../pubspec.lock').toFilePath();
    final lockFile = File(lockPath);

    // The folder name is the package name
    final package = lockFile.parent.path.split(Platform.pathSeparator).last;

    final String lockContent;
    try {
      lockContent = lockFile.readAsStringSync();
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
