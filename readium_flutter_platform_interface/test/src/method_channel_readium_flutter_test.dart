import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readium_flutter_platform_interface/src/method_channel_readium_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelReadiumFlutter', () {
    late MethodChannelReadiumFlutter methodChannelReadiumFlutter;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelReadiumFlutter = MethodChannelReadiumFlutter();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelReadiumFlutter.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelReadiumFlutter.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
