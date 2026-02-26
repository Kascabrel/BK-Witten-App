import 'package:package_info_plus/package_info_plus.dart';

/// Returns the current application version installed on the device.
///
/// This method retrieves the version information from the underlying
/// platform (Android, iOS, etc.) using the `package_info_plus` plugin.
/// Returns:
/// A [Future<String>] containing the app version defined
/// in `pubspec.yaml`.
Future<String> getLocalVersion() async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
}