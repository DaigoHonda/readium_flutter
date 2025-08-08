import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

/// The Android implementation of [ReadiumFlutterPlatform].
class ReadiumFlutterAndroid extends ReadiumFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('readium_flutter_android');

  /// Registers this class as the default instance of [ReadiumFlutterPlatform]
  static void registerWith() {
    ReadiumFlutterPlatform.instance = ReadiumFlutterAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
