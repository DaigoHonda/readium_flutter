import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readium_flutter_ios/readium_flutter_ios.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReadiumFlutterIOS', () {
    const kPlatformName = 'iOS';
    late ReadiumFlutterIOS readiumFlutter;
    late List<MethodCall> log;

    setUp(() async {
      readiumFlutter = ReadiumFlutterIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(readiumFlutter.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      ReadiumFlutterIOS.registerWith();
      expect(ReadiumFlutterPlatform.instance, isA<ReadiumFlutterIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await readiumFlutter.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
