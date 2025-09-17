# コントリビューションガイド

メールのゲーム（仮）への貢献をありがとうございます！

## 開発環境のセットアップ

### 必要な環境
- Node.js 18以上
- npm または yarn

### セットアップ手順
```bash
# リポジトリをクローン
git clone [repository-url]
cd mail-game

# 依存関係をインストール
npm install

# 開発サーバーを起動
npm run dev
```

## ブランチ戦略

- `main`: 本番環境にデプロイされる安定版
- `feature/*`: 新機能開発用ブランチ

### ワークフロー
1. `main`ブランチから`feature/機能名`ブランチを作成
2. 機能を実装・テスト
3. プルリクエストを作成
4. レビュー後、`main`にマージ

## コード規約

### フォーマッター・リンター
- **Prettier**: コードフォーマット
- **ESLint**: コード品質チェック

```bash
# フォーマット実行
npm run format

# リント実行
npm run lint
```

### プルリクエストテンプレート
PRを作成する際は、以下の項目を含めてください：
- 変更内容の概要
- 関連するIssue番号
- テスト結果
- スクリーンショット（UI変更の場合）

## テスト実行手順

### 単体テスト（Vitest）
```bash
npm run test
npm run test:watch  # ウォッチモード
```

### E2Eテスト（Playwright）
```bash
npm run test:e2e
npm run test:e2e:ui  # UIモード
```

## コミットメッセージ規約

Conventional Commitsに従ってください：

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### タイプ
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント更新
- `style`: コードスタイル変更
- `refactor`: リファクタリング
- `test`: テスト追加・修正
- `chore`: その他の変更

### 例
```
feat(game): add tutorial screen
fix(score): resolve score saving issue
docs: update README installation steps
```

## 質問・サポート

質問がある場合は、Issueを作成してください。