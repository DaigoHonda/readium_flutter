---
inclusion: always
---

# 技術スタック

## 開発環境
- **Flutter**: 3.32.8（FVMで管理）
- **FVM**: Flutterバージョン管理ツール
- **Dart**: プログラミング言語
- **Readium Mobile**: 電子書籍・オーディオブック・コミック表示のためのネイティブツールキット（Swift & Kotlin）
- **Very Good CLI**: Dart/Flutterプロジェクトの品質管理ツール

## プラットフォーム対応
- **Android**: Android 5.0+ (API Level 21以上)、Kotlin/Javaでのネイティブ実装
- **iOS**: iOS 11+、Swift/Objective-Cでのネイティブ実装
- **macOS**: Apple silicon (M1以上) 対応予定（将来のアップデート）

## 主要依存関係
- Flutter SDK
- Readium Mobile iOS SDK（EPUB・PDF・オーディオブック・コミック対応）
- Readium Mobile Android SDK（EPUB・PDF・オーディオブック・コミック対応）
- Very Good Analysis（静的解析ルール）
- 音声再生ライブラリ（オーディオブック機能用）
- 画像処理ライブラリ（コミック表示用）

## 開発方針
- **高品質なコード**: Effective Dartガイドラインに準拠
- **日本語での開発**: コメント・ドキュメント・テストを日本語で記述
- **モバイルファースト**: Android・iOS対応に特化したアプローチ
- **オープンソース**: BSD-3-Clauseライセンスでの公開
- **継続的品質改善**: 自動テスト・静的解析による品質保証

## ビルドシステム

### FVM（Flutter Version Management）セットアップ
```bash
# FVMのインストール
dart pub global activate fvm

# プロジェクトでFlutter 3.32.8を使用
fvm install 3.32.8
fvm use 3.32.8

# FVMを使用したFlutterコマンドの実行
fvm flutter --version
```

### Very Good CLI セットアップ
```bash
# Very Good CLIのインストール
dart pub global activate very_good_cli

# プロジェクトの初期化（既存プロジェクトの場合）
fvm flutter pub get
very_good packages get --recursive

# 依存関係の更新
very_good packages get
```

### 開発用コマンド
```bash
# プロジェクトの依存関係を取得（再帰的）
very_good packages get --recursive

# コードの静的解析（Very Good Analysis使用）
very_good analyze

# コードフォーマット
very_good format

# テスト実行（カバレッジ付き）
very_good test --coverage

# テストカバレッジレポート生成
very_good coverage

# サンプルアプリの実行（iOS）
fvm flutter run -d ios --flavor development

# サンプルアプリの実行（Android）
fvm flutter run -d android --flavor development
```

### パッケージ管理
- `pubspec.yaml`でFlutter依存関係を管理
- `very_good_analysis`による厳格な静的解析ルール
- ネイティブ依存関係はプラットフォーム固有の設定ファイルで管理
  - iOS: `ios/readium_flutter.podspec`
  - Android: `android/build.gradle`

## コード品質管理

### 静的解析
- **Very Good Analysis**: 厳格なDartコーディング規約
- **カスタムルール**: プロジェクト固有の品質基準
- **CI/CD統合**: GitHub Actionsでの自動チェック

### テスト戦略
- **単体テスト**: 90%以上のカバレッジを目標、日本語でのテスト記述
- **ウィジェットテスト**: UI コンポーネントのテスト
- **統合テスト**: プラットフォーム間での動作確認
- **パフォーマンステスト**: 大容量EPUB・PDF・オーディオブック・コミックファイルでの性能検証
- **メディアテスト**: 音声再生・画像表示機能のテスト
- **フォーマット互換性テスト**: 各種ファイル形式での動作確認

### コードフォーマット
- **Dart Format**: 標準フォーマッター
- **Import Sort**: インポート文の自動整理
- **Pre-commit Hook**: コミット前の自動フォーマット

### 品質メトリクス
```bash
# コードカバレッジの確認（90%以上を維持）
very_good coverage --min-coverage 90

# 複雑度の測定
dart pub global activate dart_code_metrics
metrics lib

# 依存関係の脆弱性チェック
dart pub deps

# パフォーマンス測定（各種フォーマット対応）
fvm flutter test integration_test/epub_performance_test.dart
fvm flutter test integration_test/audiobook_performance_test.dart
fvm flutter test integration_test/comic_performance_test.dart
fvm flutter test integration_test/pdf_performance_test.dart
```

### CI/CD パイプライン
- **GitHub Actions**: 自動テスト・ビルド・デプロイ
- **品質ゲート**: テストカバレッジ90%以上、静的解析エラーゼロ
- **自動リリース**: セマンティックバージョニング
- **プラットフォーム検証**: Android・iOS両方での動作確認
- **フォーマット検証**: EPUB・PDF・オーディオブック・コミック各形式での動作確認
- **パフォーマンス監視**: 大容量ファイル処理・音声再生・画像表示の性能測定
- **互換性テスト**: 各種デバイス・OSバージョンでの動作確認
