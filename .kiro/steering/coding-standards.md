---
inclusion: fileMatch
fileMatchPattern: ['**/*.dart', '**/*.yaml', '**/*.yml', 'pubspec.*']
---

# Dartコーディング規約（very_good_analysisに準拠）

## 基本原則
- `very_good_analysis`の厳格なルールセットに準拠
- `very_good format`を使用してコードを自動フォーマットする
- `very_good analyze`でコード品質を確保する
- Effective Dartをベースとした高品質なコード標準を適用
- 清潔で読みやすく、保守しやすいコードを書く
- **日本語での開発**: コメント・ドキュメント・エラーメッセージを日本語で記述

## 命名規則（very_good_analysis準拠）
- **クラス、enum、typedef、型パラメータ**: `UpperCamelCase`
- **ライブラリ、パッケージ、ディレクトリ、ソースファイル**: `lowercase_with_underscores`
- **変数、関数、メソッド、パラメータ**: `lowerCamelCase`
- **定数**: `lowerCamelCase`（SCREAMING_CAPSは使用しない）
- **プライベートメンバー**: アンダースコア（`_`）で開始

## インポートとライブラリ構成
- `dart:`ライブラリを最初にインポート
- `package:`ライブラリを次にインポート
- 相対インポートを最後にインポート
- 各グループ間に空行を挿入
- アルファベット順にソート

## コード構成
- 1行あたり80文字を推奨
- 適切な空白とインデントを使用（2スペース）
- 関数とメソッドは小さく、単一責任に保つ
- 適切なコメントとドキュメンテーションを追加

## 型注釈
- パブリックAPIには明示的な型注釈を使用
- ローカル変数では型推論を活用
- `var`、`final`、`const`を適切に使い分ける

## プラットフォーム固有実装

### Method Channel実装
- プラットフォームチャネル名は`snake_case`で統一
- メソッド名は`lowerCamelCase`で統一
- エラーハンドリングは日本語メッセージで実装
- 非同期処理は適切に`async`/`await`を使用

### ネイティブ連携
- **Android**: Kotlinでの実装を推奨、Javaも可
- **iOS**: Swiftでの実装を推奨、Objective-Cも可
- データ型変換は明示的に行う
- プラットフォーム固有の例外は適切にDart例外に変換

### 例外処理の例
```dart
// 良い例：プラットフォーム固有例外の適切な変換
try {
  final result = await methodChannel.invokeMethod('readEpub', args);
  return result;
} on PlatformException catch (e) {
  switch (e.code) {
    case 'FILE_NOT_FOUND':
      throw FileNotFoundException('指定されたEPUBファイルが見つかりません: ${e.message}');
    case 'INVALID_FORMAT':
      throw InvalidFormatException('無効なEPUBフォーマットです: ${e.message}');
    default:
      throw ReadiumException('EPUBの読み込みに失敗しました: ${e.message}');
  }
}
```

## メディア処理ガイドライン

### 電子書籍・PDF処理
- 大容量ファイルの処理は非同期で実装
- メモリ使用量を考慮したストリーミング処理
- ページング処理は効率的なアルゴリズムを使用

### オーディオブック処理
- 音声ファイルの再生は適切なライフサイクル管理
- バックグラウンド再生への対応
- 音声品質とファイルサイズのバランスを考慮

## ドキュメント規約

### コメント
- 「何を」ではなく「なぜ」を説明するコメントを書く
- コードの変更に合わせてコメントを最新に保つ
- Dartdocコメント（`///`）を使用してAPIドキュメントを作成
- **日本語でのコメント記述**: 技術的な説明も日本語で記述
- コードを再記述するだけの明白なコメントは避ける

### ドキュメンテーション
- パブリックAPIには必ずDartdocコメントを追加
- 使用例を含める（日本語での説明付き）
- パラメータと戻り値を説明する
- **機能別ドキュメント**: EPUB・PDF・オーディオブック・コミック機能別に整理

```dart
/// EPUB電子書籍を読み込んで表示するためのウィジェット
///
/// リフロー型・固定レイアウト型の両方に対応し、
/// ページ移動や目次表示などの基本的な読書機能を提供します。
///
/// 使用例:
/// ```dart
/// EpubReader(
///   filePath: '/path/to/book.epub',
///   onPageChanged: (pageIndex) {
///     print('現在のページ: $pageIndex');
///   },
/// )
/// ```
class EpubReader extends StatefulWidget {
  // 実装
}
```

## エラーハンドリング

### カスタム例外クラス
- 機能別に適切な例外クラスを定義
- エラーメッセージは日本語で記述
- デバッグ情報を含める

```dart
// 良い例：機能別例外クラス
class ReadiumException implements Exception {
  const ReadiumException(this.message, [this.details]);

  final String message;
  final String? details;

  @override
  String toString() => 'ReadiumException: $message${details != null ? ' ($details)' : ''}';
}

class EpubException extends ReadiumException {
  const EpubException(super.message, [super.details]);
}

class AudiobookException extends ReadiumException {
  const AudiobookException(super.message, [super.details]);
}

class ComicException extends ReadiumException {
  const ComicException(super.message, [super.details]);
}
```

### エラーメッセージガイドライン
- ユーザーフレンドリーな日本語メッセージ
- 技術的詳細はデバッグ情報として分離
- 解決方法のヒントを含める
- `try-catch`ブロックを適切に使用
- リソースの適切なクリーンアップを行う

## テストガイドライン

### テスト構成
- `test`パッケージを使用
- テスト名とグループ名は日本語で記述（test-guidelines.mdに準拠）
- `group`を使用してテストを整理
- モックとスタブを適切に使用
- カバレッジ90%以上を目標

### プラットフォーム固有テストの例
```dart
// 良い例：プラットフォーム固有機能のテスト
group('EPUB読み込み機能', () {
  late MockMethodChannel mockChannel;

  setUp(() {
    mockChannel = MockMethodChannel();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(mockChannel, mockChannel.handler);
  });

  test('有効なEPUBファイルを正常に読み込む', () async {
    // テスト実装
  });

  test('無効なファイルパスの場合、FileNotFoundExceptionをスローする', () async {
    // テスト実装
  });
});
```

### パフォーマンステスト
- 大容量ファイル処理の性能測定
- メモリ使用量の監視
- 各種フォーマット別の性能検証

## パフォーマンスの考慮事項

### 一般的なパフォーマンス
- 不要なオブジェクト生成を避ける
- `const`コンストラクタを活用
- 適切なコレクション型を選択
- 非同期処理を適切に使用（`async`/`await`）
