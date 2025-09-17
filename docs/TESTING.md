# テスト戦略

## テスト概要

このプロジェクトでは、品質を保証するために複数レベルのテストを実装しています。

## テストの種類

### 1. 単体テスト (Unit Tests)
**フレームワーク**: Vitest

**対象**:
- ユーティリティ関数
- ビジネスロジック
- カスタムフック
- コンポーネントの単体機能

**実行方法**:
```bash
# 全テスト実行
npm run test

# ウォッチモード
npm run test:watch

# カバレッジ付き実行
npm run test:coverage
```

### 2. E2Eテスト (End-to-End Tests)
**フレームワーク**: Playwright

**対象**:
- ユーザーフロー全体
- ゲームプレイシナリオ
- スコア保存・表示
- レスポンシブデザイン

**実行方法**:
```bash
# 全E2Eテスト実行
npm run test:e2e

# UIモードで実行
npm run test:e2e:ui

# 特定のブラウザで実行
npm run test:e2e -- --project=chromium
```

## テストファイル構成

```
tests/
├── unit/                   # 単体テスト
│   ├── components/         # コンポーネントテスト
│   ├── services/          # サービステスト
│   ├── utils/             # ユーティリティテスト
│   └── hooks/             # フックテスト
├── e2e/                   # E2Eテスト
│   ├── game-flow.spec.ts  # ゲームフローテスト
│   ├── score.spec.ts      # スコア機能テスト
│   └── responsive.spec.ts # レスポンシブテスト
└── fixtures/              # テストデータ
    ├── mockData.ts        # モックデータ
    └── testHelpers.ts     # テストヘルパー
```

## テストケース例

### 単体テスト例
```typescript
// tests/unit/utils/scoreCalculator.test.ts
import { describe, it, expect } from 'vitest'
import { calculateScore } from '@/utils/scoreCalculator'

describe('scoreCalculator', () => {
  it('should calculate correct score for basic game', () => {
    const result = calculateScore({
      timeElapsed: 60,
      correctAnswers: 10,
      totalQuestions: 10
    })
    
    expect(result).toBe(1000)
  })
})
```

### E2Eテスト例
```typescript
// tests/e2e/game-flow.spec.ts
import { test, expect } from '@playwright/test'

test('complete game flow', async ({ page }) => {
  await page.goto('/')
  
  // タイトル画面
  await expect(page.locator('h1')).toContainText('メールのゲーム')
  await page.click('button:has-text("ゲーム開始")')
  
  // チュートリアル
  await expect(page.locator('.tutorial')).toBeVisible()
  await page.click('button:has-text("スキップ")')
  
  // ゲームプレイ
  await expect(page.locator('.game-canvas')).toBeVisible()
  
  // スコア保存確認
  await page.waitForSelector('.result-screen')
  await expect(page.locator('.score')).toBeVisible()
})
```

## CI/CDでのテスト統合

### GitHub Actions設定
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm run test:coverage
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

### テスト実行の注意事項

1. **環境変数**: テスト用の環境変数を設定
2. **データベース**: テスト用のSupabaseプロジェクトを使用
3. **並列実行**: E2Eテストは並列実行を避ける
4. **タイムアウト**: 長時間実行されるテストにはタイムアウトを設定

## テストデータ管理

### モックデータ
```typescript
// tests/fixtures/mockData.ts
export const mockGameData = {
  player: {
    id: 'test-player-1',
    name: 'テストプレイヤー'
  },
  scores: [
    { score: 1000, date: '2025-01-01' },
    { score: 1500, date: '2025-01-02' }
  ]
}
```

### テストヘルパー
```typescript
// tests/fixtures/testHelpers.ts
export const setupTestGame = async () => {
  // テスト用ゲーム環境のセットアップ
}

export const cleanupTestData = async () => {
  // テストデータのクリーンアップ
}
```

## カバレッジ目標

- **単体テスト**: 80%以上
- **E2Eテスト**: 主要フロー100%カバー
- **クリティカルパス**: 100%カバー

## テスト実行のベストプラクティス

### 開発時
1. 新機能実装前にテストを書く（TDD）
2. コミット前に関連テストを実行
3. 定期的にE2Eテストを実行

### CI/CD
1. 全てのプルリクエストでテスト実行
2. テスト失敗時はマージを禁止
3. カバレッジレポートを確認

## トラブルシューティング

### よくある問題

**テストが不安定**:
- 非同期処理の適切な待機
- テストデータの分離
- 環境依存の排除

**E2Eテストが遅い**:
- 不要な待機時間の削除
- 並列実行の最適化
- テストケースの統合

**カバレッジが低い**:
- 未テストコードの特定
- エッジケースの追加
- 統合テストの強化