# WarMail: ATK & DEF

メールは魔物。敵を送信せよ。

WarMail: ATK & DEF は、戦況報告が飛び交う受信箱を捌いて領域を防衛するブラウザ風インターフェースを題材にした Flutter 製のシングルプレイゲームです。本リポジトリでは [docs/MVP_RequirementsDefinition.md](docs/MVP_RequirementsDefinition.md) をもとに MVP を実装しています。

## クイックスタート
```bash
flutter pub get
flutter run
```

### 推奨環境
- Flutter 3.22 以降
- Dart 3.2 以降

## 実装済みの MVP 機能
- **タイトル画面**: 世界観紹介とスコア表示、チュートリアルへの導線
- **チュートリアル**: ゲームルール（カテゴリ判定・アクション・リソース管理）の 3 ステップ解説
- **ゲームループ**: 受信メールを選択し、`返信 / アーカイブ / 削除` の判断でスコア・エネルギー・残り時間が変動
- **スコア算出**: 正解アクションで加点とコンボボーナス、失敗で減点とエネルギーペナルティ
- **スコア保存**: `shared_preferences` を利用したベストスコアと直近スコアのローカル保存
- **レスポンシブ UI**: デスクトップレイアウトを基調に、横幅が狭い場合はリストと本文を縦積みに切り替え

## プロジェクト構成
```
lib/
 ├─ app.dart                # MaterialApp とルーティング
 ├─ main.dart               # エントリーポイント
 ├─ theme/                  # ダークテーマ定義
 ├─ services/score_storage.dart
 └─ features/
     ├─ title/              # タイトル画面
     ├─ tutorial/           # チュートリアル
     └─ game/               # メールゲーム本体 (データ・状態・UI)
```

## テスト
```bash
flutter test
```

## ライセンス
このプロジェクトのライセンスについては [LICENSE.md](LICENSE.md) を参照してください。
