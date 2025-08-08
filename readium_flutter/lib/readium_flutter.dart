import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

ReadiumFlutterPlatform get _platform => ReadiumFlutterPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
