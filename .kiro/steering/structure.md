---
inclusion: always
---

# プロジェクト構造

## Federated Plugin アーキテクチャ

Dart公式推奨のFederated pluginsアーキテクチャに従い、以下の3つのパッケージで構成します：

### 1. App-facing Package（readium_flutter）
ユーザーが直接依存するメインパッケージ

```
readium_flutter/
├── lib/
│   ├── src/
│   │   ├── models/              # 共通データモデル
│   │   │   ├── document.dart    # 文書の抽象モデル
│   │   │   ├── reading_position.dart
│   │   │   ├── table_of_contents.dart
│   │   │   └── reader_settings.dart
│   │   ├── exceptions/          # 共通例外クラス
│   │   │   ├── readium_exception.dart
│   │   │   ├── file_not_found_exception.dart
│   │   │   └── unsupported_format_exception.dart
│   │   └── widgets/             # UIウィジェット
│   │       ├── readium_reader.dart    # 統合リーダーウィジェット
│   │       └── reader_controls.dart   # 読書制御UI
│   └── readium_flutter.dart     # パブリックAPI
├── example/                      # サンプルアプリ
├── test/                         # 単体テスト
├── pubspec.yaml                 # 依存関係（platform interfaceとendorsed packages）
├── README.md
└── CHANGELOG.md
```

### 2. Platform Interface Package（readium_flutter_platform_interface）
プラットフォーム実装の共通インターフェース

```
readium_flutter_platform_interface/
├── lib/
│   ├── src/
│   │   ├── method_channel/      # Method Channel実装
│   │   │   └── method_channel_readium_flutter.dart
│   │   ├── models/              # プラットフォーム共通モデル
│   │   └── exceptions/          # プラットフォーム例外
│   ├── method_channel_readium_flutter.dart
│   └── readium_flutter_platform_interface.dart
├── test/
├── pubspec.yaml
├── README.md
└── CHANGELOG.md
```

### 3. Platform Packages（各プラットフォーム実装）

#### Android実装（readium_flutter_android）
```
readium_flutter_android/
├── lib/
│   ├── src/
│   │   └── readium_flutter_android.dart
│   └── readium_flutter_android.dart
├── android/
│   ├── src/main/kotlin/
│   │   └── net/devhonda/readium_flutter_android/
│   │       ├── ReadiumFlutterAndroidPlugin.kt
│   │       ├── epub/            # EPUB処理
│   │       ├── pdf/             # PDF処理
│   │       ├── audiobook/       # オーディオブック処理
│   │       └── comic/           # コミック処理
│   └── build.gradle
├── test/
├── pubspec.yaml                 # platform interfaceに依存
├── README.md
└── CHANGELOG.md
```

#### iOS実装（readium_flutter_ios）
```
readium_flutter_ios/
├── lib/
│   ├── src/
│   │   └── readium_flutter_ios.dart
│   └── readium_flutter_ios.dart
├── ios/
│   ├── Classes/
│   │   ├── ReadiumFlutterIosPlugin.swift
│   │   ├── Epub/                # EPUB処理
│   │   ├── Pdf/                 # PDF処理
│   │   ├── Audiobook/           # オーディオブック処理
│   │   └── Comic/               # コミック処理
│   └── readium_flutter_ios.podspec
├── test/
├── pubspec.yaml                 # platform interfaceに依存
├── README.md
└── CHANGELOG.md
```

#### Web実装（readium_flutter_web）
```
readium_flutter_web/
├── lib/
│   ├── src/
│   │   └── readium_flutter_web.dart
│   └── readium_flutter_web.dart
├── test/
├── pubspec.yaml                 # platform interfaceに依存
├── README.md
└── CHANGELOG.md
```

## Federated Plugin パッケージ別の役割

### App-facing Package（readium_flutter）
- **目的**: ユーザーが直接使用するパブリックAPI
- **責任**:
  - 統一されたAPIの提供
  - プラットフォーム実装の抽象化
  - UIウィジェットの提供
- **依存関係**: platform interfaceとendorsed platform packages
- **pubspec.yaml設定例**:
```yaml
dependencies:
  readium_flutter_platform_interface: ^1.0.0

flutter:
  plugin:
    platforms:
      android:
        default_package: readium_flutter_android
      ios:
        default_package: readium_flutter_ios
      web:
        default_package: readium_flutter_web
```

### Platform Interface Package（readium_flutter_platform_interface）
- **目的**: プラットフォーム実装の共通インターフェース定義
- **責任**:
  - 抽象クラス・インターフェースの定義
  - Method Channelのデフォルト実装
  - 共通モデル・例外クラスの提供
- **実装パターン**:
  - 抽象基底クラス `ReadiumFlutterPlatform`
  - デフォルト実装 `MethodChannelReadiumFlutter`
- **pubspec.yaml設定例**:
```yaml
flutter:
  plugin:
    platforms:
      android:
        pluginClass: ReadiumFlutterPlugin
      ios:
        pluginClass: ReadiumFlutterPlugin
```

### Platform Packages（各プラットフォーム実装）

#### Android Package（readium_flutter_android）
- **目的**: Android固有の実装
- **責任**: platform interfaceの具体的実装
- **言語**: Kotlin
- **依存関係**: Readium Mobile Android SDK
- **pubspec.yaml設定例**:
```yaml
dependencies:
  readium_flutter_platform_interface: ^1.0.0

flutter:
  plugin:
    implements: readium_flutter
    platforms:
      android:
        pluginClass: ReadiumFlutterAndroidPlugin
```

#### iOS Package（readium_flutter_ios）
- **目的**: iOS固有の実装
- **責任**: platform interfaceの具体的実装
- **言語**: Swift
- **依存関係**: Readium Mobile iOS SDK
- **pubspec.yaml設定例**:
```yaml
dependencies:
  readium_flutter_platform_interface: ^1.0.0

flutter:
  plugin:
    implements: readium_flutter
    platforms:
      ios:
        pluginClass: ReadiumFlutterIosPlugin
```

#### Web Package（readium_flutter_web）
- **目的**: Web固有の実装
- **責任**: platform interfaceの具体的実装
- **実装**: Dart + JavaScript interop
- **pubspec.yaml設定例**:
```yaml
dependencies:
  readium_flutter_platform_interface: ^1.0.0

flutter:
  plugin:
    implements: readium_flutter
    platforms:
      web:
        pluginClass: ReadiumFlutterWeb
        fileName: readium_flutter_web.dart
```

## Federated Plugin開発の利点

### 1. 関心の分離
- **プラットフォーム専門性**: 各プラットフォームの専門家が独立して開発可能
- **保守性向上**: プラットフォーム固有の変更が他に影響しない
- **テスト容易性**: 各パッケージを独立してテスト可能

### 2. エンドースメント（Endorsement）
- **公式サポート**: メインパッケージ作者による承認
- **自動依存解決**: ユーザーは追加設定不要
- **品質保証**: 統一された品質基準

### 3. 段階的プラットフォーム対応
- **初期リリース**: Android・iOS対応でスタート
- **段階的拡張**: Web・macOS・Windows・Linuxを順次追加
- **独立リリース**: 各プラットフォームが独立してバージョンアップ可能

## 開発ツール設定

### FVM設定（全パッケージ共通）
```json
// .fvm/fvm_config.json
{
  "flutter": "3.32.8"
}
```

### 静的解析設定（全パッケージ共通）
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

### CI/CD設定（各パッケージ独立）
- **マトリックス戦略**: 各パッケージを並列でテスト
- **依存関係管理**: platform interfaceの変更時に全platform packagesをテスト
- **リリース自動化**: セマンティックバージョニングによる自動リリース

## パッケージ間の依存関係

### 依存関係の方向
```
App-facing Package (readium_flutter)
    ↓ depends on
Platform Interface Package (readium_flutter_platform_interface)
    ↑ implemented by
Platform Packages (readium_flutter_android, readium_flutter_ios, etc.)
```

### バージョン管理戦略
- **Platform Interface**: セマンティックバージョニング（破壊的変更は慎重に）
- **Platform Packages**: Platform Interfaceのバージョンに依存
- **App-facing Package**: 安定版のPlatform Interfaceに依存

### 開発ワークフロー
1. **Platform Interface変更**: 新機能・APIの追加
2. **Platform Packages更新**: 各プラットフォームでの実装
3. **App-facing Package更新**: 新機能の統合とUIの提供
4. **統合テスト**: 全パッケージでの動作確認

## ファイル命名規則

### パッケージ命名
- **App-facing**: `readium_flutter`
- **Platform Interface**: `readium_flutter_platform_interface`
- **Platform Packages**: `readium_flutter_[platform]`
  - Android: `readium_flutter_android`
  - iOS: `readium_flutter_ios`
  - Web: `readium_flutter_web`

### Dartファイル命名
- **ライブラリファイル**: `snake_case.dart`
- **クラス名**: `UpperCamelCase`
- **変数・関数名**: `lowerCamelCase`
- **プラットフォーム実装**: `readium_flutter_[platform].dart`

### ネイティブファイル命名
- **Android**: `ReadiumFlutter[Platform]Plugin.kt`（Kotlin）
- **iOS**: `ReadiumFlutter[Platform]Plugin.swift`（Swift）
- **パッケージ構造**: `net.devhonda.readium_flutter_[platform]`

### テストファイル命名
- **単体テスト**: `*_test.dart`
- **ウィジェットテスト**: `*_widget_test.dart`
- **統合テスト**: `*_integration_test.dart`
- **日本語テスト名**: グループ名・テスト名は日本語で記述

## 実装例：Platform Interface

### 抽象基底クラス
```dart
// readium_flutter_platform_interface/lib/src/readium_flutter_platform_interface.dart
abstract class ReadiumFlutterPlatform extends PlatformInterface {
  ReadiumFlutterPlatform() : super(token: _token);

  static final Object _token = Object();
  static ReadiumFlutterPlatform _instance = MethodChannelReadiumFlutter();

  static ReadiumFlutterPlatform get instance => _instance;

  static set instance(ReadiumFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 文書を読み込む
  Future<String> loadDocument(String filePath);

  /// ページ数を取得する
  Future<int> getPageCount();

  /// 指定ページに移動する
  Future<void> goToPage(int pageNumber);
}
```

### Method Channel実装
```dart
// readium_flutter_platform_interface/lib/src/method_channel_readium_flutter.dart
class MethodChannelReadiumFlutter extends ReadiumFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('readium_flutter');

  @override
  Future<String> loadDocument(String filePath) async {
    final result = await methodChannel.invokeMethod<String>(
      'loadDocument',
      {'filePath': filePath},
    );
    return result!;
  }

  @override
  Future<int> getPageCount() async {
    final result = await methodChannel.invokeMethod<int>('getPageCount');
    return result!;
  }

  @override
  Future<void> goToPage(int pageNumber) async {
    await methodChannel.invokeMethod<void>(
      'goToPage',
      {'pageNumber': pageNumber},
    );
  }
}
```

### Platform Package実装例
```dart
// readium_flutter_android/lib/src/readium_flutter_android.dart
class ReadiumFlutterAndroid extends ReadiumFlutterPlatform {
  static void registerWith() {
    ReadiumFlutterPlatform.instance = ReadiumFlutterAndroid();
  }

  @override
  Future<String> loadDocument(String filePath) async {
    // Android固有の実装
    return await methodChannel.invokeMethod<String>(
      'loadDocument',
      {'filePath': filePath},
    );
  }
}
```

## 品質管理

### パッケージ別品質基準
- **Platform Interface**: 100%テストカバレッジ（インターフェース定義のため）
- **Platform Packages**: 90%以上テストカバレッジ
- **App-facing Package**: 90%以上テストカバレッジ + 統合テスト

### CI/CD戦略
```yaml
# .github/workflows/test.yml
strategy:
  matrix:
    package:
      - readium_flutter
      - readium_flutter_platform_interface
      - readium_flutter_android
      - readium_flutter_ios
      - readium_flutter_web
```

### リリース管理
- **独立リリース**: 各パッケージが独立してリリース
- **互換性保証**: Platform Interfaceの破壊的変更は慎重に管理
- **エンドースメント更新**: 新しいPlatform Packageのリリース時にApp-facingパッケージを更新
