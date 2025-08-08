---
inclusion: always
---

# テストガイドライン

## テスト記述の基本方針

### 言語設定
- **テストグループ名（`group`）**: 必ず日本語で記述する
- **テスト名（`test`）**: 必ず日本語で記述する
- **テストの説明**: 期待される動作を日本語で明確に記述する
- **コメント**: テストロジックの説明も日本語で記述する

### 品質基準
- **カバレッジ**: 90%以上を維持する
- **very_good_analysis**: 厳格な静的解析ルールに準拠
- **テスト実行**: `very_good test --coverage`を使用

### テスト名の命名規則

#### グループ名（`group`）
- 機能やクラス名を日本語で記述
- 例: `'ReadiumFlutter'`, `'プラットフォーム名の取得'`, `'EPUB読み込み機能'`

#### テスト名（`test`）
- 「〜する」「〜を返す」「〜をスローする」などの動作を明確に記述
- 条件と期待結果を含める
- 例:
  - `'プラットフォーム実装が存在する場合、正しい名前を返す'`
  - `'無効なファイルパスの場合、例外をスローする'`
  - `'EPUBファイルを正常に読み込む'`

## テスト種別

### 単体テスト（Unit Tests）
- **対象**: 個別のクラス・メソッドの動作
- **場所**: `test/`ディレクトリ
- **命名**: `*_test.dart`
- **実行**: `very_good test`

### ウィジェットテスト（Widget Tests）
- **対象**: UIコンポーネントの動作
- **場所**: `test/widgets/`ディレクトリ
- **命名**: `*_widget_test.dart`
- **実行**: `very_good test`

### 統合テスト（Integration Tests）
- **対象**: プラットフォーム間での動作確認
- **場所**: `integration_test/`ディレクトリ
- **命名**: `*_integration_test.dart`
- **実行**: `very_good test integration_test`

### パフォーマンステスト（Performance Tests）
- **対象**: 各フォーマットの性能測定
- **場所**: `integration_test/`ディレクトリ
- **命名**: `*_performance_test.dart`
- **実行**: 専用のパフォーマンス測定スクリプト

### 機能別テスト構造

#### 統合リーダー機能のテスト例

```dart
void main() {
  group('ReadiumFlutter統合リーダー', () {
    group('ファイル読み込み機能', () {
      test('EPUBファイルを正常に読み込む', () async {
        // テスト実装
      });

      test('PDFファイルを正常に読み込む', () async {
        // テスト実装
      });

      test('オーディオブックファイルを正常に読み込む', () async {
        // テスト実装
      });

      test('コミックファイルを正常に読み込む', () async {
        // テスト実装
      });

      test('サポートされていないファイル形式の場合、UnsupportedFormatExceptionをスローする', () async {
        // テスト実装
      });
    });

    group('読書制御機能', () {
      test('次のページに正常に移動する', () async {
        // テスト実装
      });

      test('前のページに正常に移動する', () async {
        // テスト実装
      });

      test('指定したページに正常にジャンプする', () async {
        // テスト実装
      });

      test('無効なページ番号の場合、InvalidPageExceptionをスローする', () async {
        // テスト実装
      });
    });

    group('プラットフォーム固有機能', () {
      test('Androidプラットフォームで正常に動作する', () async {
        // テスト実装
      });

      test('iOSプラットフォームで正常に動作する', () async {
        // テスト実装
      });

      test('プラットフォーム固有エラーを適切にDart例外に変換する', () async {
        // テスト実装
      });
    });
  });
}
```

## モックとテストヘルパー

### Method Channelのモック

```dart
/// Method Channelのモッククラス
///
/// プラットフォーム固有の機能をテストするために使用します。
class MockReadiumMethodChannel {
  static const MethodChannel _channel = MethodChannel('net.devhonda.readium_flutter');

  /// モックレスポンスを設定
  void setMockMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, handler);
  }

  /// モックを初期化
  void setUp() {
    setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'loadDocument':
          return {'success': true, 'documentId': 'test_document'};
        case 'getPageCount':
          return 100;
        default:
          throw PlatformException(code: 'UNIMPLEMENTED');
      }
    });
  }

  /// モックをクリーンアップ
  void tearDown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }
}
```

### テストヘルパー関数

```dart
/// テスト用のサンプルファイルパスを生成
String getTestFilePath(String fileName) {
  return 'test/assets/$fileName';
}

/// テスト用のEPUBファイルを作成
Future<File> createTestEpubFile() async {
  // テスト用EPUBファイルの作成ロジック
}

/// テスト用のPDFファイルを作成
Future<File> createTestPdfFile() async {
  // テスト用PDFファイルの作成ロジック
}
```

## パフォーマンステスト

### 測定項目
- **読み込み時間**: 各フォーマットのファイル読み込み速度
- **メモリ使用量**: 大容量ファイル処理時のメモリ消費
- **レンダリング性能**: ページ表示の応答速度
- **音声再生性能**: オーディオブック再生の遅延

### パフォーマンステストの例

```dart
void main() {
  group('パフォーマンステスト', () {
    group('EPUB読み込み性能', () {
      test('小容量EPUBファイル（1MB未満）を3秒以内に読み込む', () async {
        final stopwatch = Stopwatch()..start();

        // EPUB読み込み処理
        await readiumReader.loadDocument('test/assets/small_book.epub');

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      });

      test('大容量EPUBファイル（10MB以上）を10秒以内に読み込む', () async {
        final stopwatch = Stopwatch()..start();

        // 大容量EPUB読み込み処理
        await readiumReader.loadDocument('test/assets/large_book.epub');

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10000));
      });
    });

    group('メモリ使用量テスト', () {
      test('大容量ファイル処理時のメモリ使用量が制限内に収まる', () async {
        // メモリ使用量の測定ロジック
        final initialMemory = await getMemoryUsage();

        await readiumReader.loadDocument('test/assets/large_book.epub');

        final finalMemory = await getMemoryUsage();
        final memoryIncrease = finalMemory - initialMemory;

        // メモリ増加量が100MB以下であることを確認
        expect(memoryIncrease, lessThan(100 * 1024 * 1024));
      });
    });
  });
}
```

## エラーハンドリングテスト

### カスタム例外のテスト

```dart
group('例外処理テスト', () {
  test('ファイルが見つからない場合、FileNotFoundExceptionをスローする', () async {
    expect(
      () => readiumReader.loadDocument('nonexistent_file.epub'),
      throwsA(isA<FileNotFoundException>()),
    );
  });

  test('無効なEPUBフォーマットの場合、EpubExceptionをスローする', () async {
    expect(
      () => readiumReader.loadDocument('test/assets/invalid.epub'),
      throwsA(isA<EpubException>()),
    );
  });

  test('プラットフォームエラーが適切にDart例外に変換される', () async {
    // プラットフォームエラーのシミュレーション
    mockChannel.setMockMethodCallHandler((call) async {
      throw PlatformException(code: 'NATIVE_ERROR', message: 'Native error occurred');
    });

    expect(
      () => readiumReader.loadDocument('test/assets/sample.epub'),
      throwsA(isA<ReadiumException>()),
    );
  });
});
```

## コメントとドキュメント

### Dartdocコメント
- パブリックAPIには必ず日本語のDartdocコメントを追加
- テストヘルパークラスやモッククラスにも説明を追加

### インラインコメント
- テストの複雑な部分には日本語でコメントを追加
- 「なぜ」そのテストが必要かを説明する

## テスト品質の基準

### 可読性
- テスト名を読むだけで何をテストしているかが分かる
- 日本語での記述により、チーム全体での理解を促進

### 保守性
- テスト名が機能の変更に合わせて更新される
- 日本語での記述により、仕様変更時の影響範囲が把握しやすい

### 一貫性
- プロジェクト全体で統一された日本語テスト記述スタイル
- 全てのプラットフォーム固有テストで同じ命名規則を適用

## CI/CD統合

### GitHub Actionsでのテスト実行

```yaml
# .github/workflows/test.yml での設定例
- name: テスト実行
  run: |
    very_good test --coverage --min-coverage 90

- name: 統合テスト実行
  run: |
    very_good test integration_test

- name: パフォーマンステスト実行
  run: |
    flutter test integration_test/epub_performance_test.dart
    flutter test integration_test/pdf_performance_test.dart
```

### テスト結果の品質ゲート
- **カバレッジ**: 90%以上必須
- **テスト成功率**: 100%必須
- **パフォーマンス基準**: 各フォーマットの読み込み時間制限
- **静的解析**: very_good_analysisエラーゼロ

## 例外事項

### 英語のままにする場合
- Dartの予約語やメソッド名（`setUp`, `tearDown`など）
- 外部ライブラリのAPI名やクラス名
- 技術的な固有名詞で日本語訳が不自然な場合

### 併記する場合
- 複雑な技術用語は英語併記も可能
- 例: `'HTTP通信エラー（HttpException）をスローする'`
