import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:readium_flutter/readium_flutter.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

class MockReadiumFlutterPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ReadiumFlutterPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReadiumFlutter', () {
    late ReadiumFlutterPlatform readiumFlutterPlatform;

    setUp(() {
      readiumFlutterPlatform = MockReadiumFlutterPlatform();
      ReadiumFlutterPlatform.instance = readiumFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => readiumFlutterPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => readiumFlutterPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
