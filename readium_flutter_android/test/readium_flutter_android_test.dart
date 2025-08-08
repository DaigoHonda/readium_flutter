import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readium_flutter_android/readium_flutter_android.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReadiumFlutterAndroid', () {
    const kPlatformName = 'Android';
    late ReadiumFlutterAndroid readiumFlutter;
    late List<MethodCall> log;

    setUp(() async {
      readiumFlutter = ReadiumFlutterAndroid();

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
      ReadiumFlutterAndroid.registerWith();
      expect(ReadiumFlutterPlatform.instance, isA<ReadiumFlutterAndroid>());
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
