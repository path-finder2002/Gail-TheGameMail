# スタイルガイド

## 概要

このドキュメントは、メールのゲーム（仮）プロジェクトにおけるコーディング規約とスタイルガイドラインを定義します。

## TypeScript / JavaScript

### 命名規則

#### 変数・関数
```typescript
// ✅ Good: camelCase
const playerScore = 100;
const gameSettings = {};
const calculateTotalScore = () => {};

// ❌ Bad: snake_case, PascalCase
const player_score = 100;
const PlayerScore = 100;
```

#### 定数
```typescript
// ✅ Good: SCREAMING_SNAKE_CASE
const MAX_PLAYER_COUNT = 4;
const DEFAULT_GAME_DURATION = 60;
const API_ENDPOINTS = {
  SCORES: '/api/scores',
  RANKINGS: '/api/rankings'
};
```

#### クラス・インターface・型
```typescript
// ✅ Good: PascalCase
class GameManager {}
interface PlayerData {}
type ScoreResult = {};

// ❌ Bad: camelCase
class gameManager {}
interface playerData {}
```

#### ファイル名
```typescript
// ✅ Good: camelCase for utilities, PascalCase for components
gameUtils.ts
scoreCalculator.ts
GameScene.ts
PlayerCard.tsx
```

### 関数定義

#### アロー関数 vs 関数宣言
```typescript
// ✅ Good: アロー関数（短い関数、コールバック）
const add = (a: number, b: number) => a + b;
const users = data.map(item => item.user);

// ✅ Good: 関数宣言（複雑な関数、ホイスティングが必要）
function calculateComplexScore(data: GameData): number {
  // 複雑な処理...
  return score;
}
```

#### 型注釈
```typescript
// ✅ Good: 明示的な型注釈
function processScore(score: number): ScoreResult {
  return { score, grade: getGrade(score) };
}

// ✅ Good: 戻り値の型が明確な場合は省略可
const isHighScore = (score: number) => score > 1000;
```

### インポート・エクスポート

#### インポート順序
```typescript
// 1. Node modules
import React from 'react';
import { useState, useEffect } from 'react';

// 2. Internal modules (absolute path)
import { GameScene } from '@/scenes/GameScene';
import { scoreService } from '@/services/scoreService';

// 3. Relative imports
import './GameComponent.css';
import { helper } from '../utils/helper';
```

#### エクスポート
```typescript
// ✅ Good: Named exports（推奨）
export const GameManager = {};
export const scoreCalculator = {};

// ✅ Good: Default export（単一の主要な機能）
export default class GameScene extends Phaser.Scene {}
```

## React

### コンポーネント定義

#### 関数コンポーネント
```tsx
// ✅ Good: アロー関数 + 型定義
interface PlayerCardProps {
  name: string;
  score: number;
  rank?: number;
}

export const PlayerCard: React.FC<PlayerCardProps> = ({ 
  name, 
  score, 
  rank 
}) => {
  return (
    <div className="player-card">
      <h3>{name}</h3>
      <p>Score: {score}</p>
      {rank && <span>Rank: {rank}</span>}
    </div>
  );
};
```

#### フック使用
```tsx
// ✅ Good: カスタムフック
const useGameState = () => {
  const [score, setScore] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  
  return { score, setScore, isPlaying, setIsPlaying };
};

// ✅ Good: useEffect依存配列
useEffect(() => {
  fetchScores();
}, [playerId]); // 依存配列を明示
```

### JSX

#### 属性の記述
```tsx
// ✅ Good: 複数属性は改行
<GameButton
  onClick={handleClick}
  disabled={isLoading}
  variant="primary"
  size="large"
>
  Start Game
</GameButton>

// ✅ Good: 単一属性は一行
<PlayerName name={player.name} />
```

#### 条件付きレンダリング
```tsx
// ✅ Good: 論理演算子
{isLoggedIn && <UserProfile />}

// ✅ Good: 三項演算子（2つの選択肢）
{isLoading ? <Spinner /> : <GameContent />}

// ✅ Good: 早期リターン（複雑な条件）
if (!user) {
  return <LoginPrompt />;
}

return <GameDashboard user={user} />;
```

## CSS / Styling

### クラス命名（BEM）
```css
/* ✅ Good: BEM記法 */
.game-card {}
.game-card__title {}
.game-card__score {}
.game-card--highlighted {}

/* ❌ Bad: 一般的すぎる名前 */
.card {}
.title {}
.red {}
```

### CSS変数
```css
/* ✅ Good: CSS変数の使用 */
:root {
  --color-primary: #007bff;
  --color-secondary: #6c757d;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
}

.game-button {
  background-color: var(--color-primary);
  padding: var(--spacing-md);
}
```

## ディレクトリ構成

### プロジェクト構造
```
src/
├── components/          # 再利用可能なコンポーネント
│   ├── ui/             # 基本UIコンポーネント
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.test.tsx
│   │   │   └── Button.module.css
│   │   └── index.ts    # バレルエクスポート
│   └── game/           # ゲーム固有のコンポーネント
├── scenes/             # Phaserシーン
├── services/           # API・ビジネスロジック
├── hooks/              # カスタムフック
├── utils/              # ユーティリティ関数
├── types/              # 型定義
└── assets/             # 静的ファイル
```

### ファイル命名
```
// ✅ Good: 一貫した命名
GameScene.ts           # Phaserシーン
PlayerCard.tsx         # Reactコンポーネント
scoreService.ts        # サービス
gameUtils.ts          # ユーティリティ
types.ts              # 型定義
constants.ts          # 定数
```

## コメント

### 関数・クラスのコメント
```typescript
/**
 * プレイヤーのスコアを計算する
 * @param gameData - ゲームデータ
 * @param timeBonus - 時間ボーナス係数
 * @returns 計算されたスコア
 */
function calculateScore(gameData: GameData, timeBonus: number): number {
  // 基本スコアの計算
  const baseScore = gameData.correctAnswers * 100;
  
  // 時間ボーナスの適用
  const bonus = Math.floor(baseScore * timeBonus);
  
  return baseScore + bonus;
}
```

### インラインコメント
```typescript
// ✅ Good: 複雑なロジックの説明
const adjustedScore = score * (1 + timeBonus); // 時間ボーナスを適用

// ✅ Good: 一時的な対応の説明
// TODO: APIの仕様変更後に修正が必要
const tempFix = data.map(item => ({ ...item, id: generateId() }));

// ❌ Bad: 自明なコメント
const total = a + b; // aとbを足す
```

## Linter / Formatter 設定

### ESLint設定
```json
{
  "extends": [
    "@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "react/prop-types": "off",
    "prefer-const": "error"
  }
}
```

### Prettier設定
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

## Git

### コミットメッセージ
```bash
# ✅ Good: Conventional Commits
feat(game): add tutorial screen
fix(score): resolve calculation error
docs: update API documentation
style: format code with prettier
refactor(ui): extract common button component
test: add unit tests for score service
chore: update dependencies

# ❌ Bad: 曖昧なメッセージ
fix bug
update code
changes
```

### ブランチ命名
```bash
# ✅ Good: 機能ブランチ
feature/tutorial-screen
feature/score-calculation
fix/memory-leak
hotfix/critical-bug
docs/api-documentation

# ❌ Bad: 曖昧な名前
new-feature
bug-fix
updates
```

## パフォーマンス

### React最適化
```tsx
// ✅ Good: React.memo for expensive components
export const ExpensiveComponent = React.memo(({ data }) => {
  return <ComplexVisualization data={data} />;
});

// ✅ Good: useMemo for expensive calculations
const expensiveValue = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// ✅ Good: useCallback for event handlers
const handleClick = useCallback(() => {
  onItemClick(item.id);
}, [item.id, onItemClick]);
```

### バンドルサイズ最適化
```typescript
// ✅ Good: 名前付きインポート
import { debounce } from 'lodash';

// ❌ Bad: デフォルトインポート（全体をインポート）
import _ from 'lodash';
```

## エラーハンドリング

### エラー境界
```tsx
// ✅ Good: エラー境界の実装
class GameErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Game Error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback />;
    }

    return this.props.children;
  }
}
```

### 非同期エラーハンドリング
```typescript
// ✅ Good: try-catch with async/await
async function fetchScores(): Promise<Score[]> {
  try {
    const response = await api.get('/scores');
    return response.data;
  } catch (error) {
    console.error('Failed to fetch scores:', error);
    throw new Error('スコアの取得に失敗しました');
  }
}
```

このスタイルガイドは、プロジェクトの成長に合わせて更新されます。新しいパターンや規約が必要になった場合は、チームで議論して追加してください。