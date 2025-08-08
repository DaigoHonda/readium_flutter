import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:readium_flutter_platform_interface/src/method_channel_readium_flutter.dart';

/// The interface that implementations of readium_flutter must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `ReadiumFlutter`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [ReadiumFlutterPlatform] methods.
abstract class ReadiumFlutterPlatform extends PlatformInterface {
  /// Constructs a ReadiumFlutterPlatform.
  ReadiumFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ReadiumFlutterPlatform _instance = MethodChannelReadiumFlutter();

  /// The default instance of [ReadiumFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelReadiumFlutter].
  static ReadiumFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ReadiumFlutterPlatform] when they register themselves.
  static set instance(ReadiumFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
