import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

/// An implementation of [ReadiumFlutterPlatform] that uses method channels.
class MethodChannelReadiumFlutter extends ReadiumFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('readium_flutter');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
