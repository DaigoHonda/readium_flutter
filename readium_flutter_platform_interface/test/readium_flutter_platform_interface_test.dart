import 'package:flutter_test/flutter_test.dart';
import 'package:readium_flutter_platform_interface/readium_flutter_platform_interface.dart';

class ReadiumFlutterMock extends ReadiumFlutterPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ReadiumFlutterPlatformInterface', () {
    late ReadiumFlutterPlatform readiumFlutterPlatform;

    setUp(() {
      readiumFlutterPlatform = ReadiumFlutterMock();
      ReadiumFlutterPlatform.instance = readiumFlutterPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await ReadiumFlutterPlatform.instance.getPlatformName(),
          equals(ReadiumFlutterMock.mockPlatformName),
        );
      });
    });
  });
}
