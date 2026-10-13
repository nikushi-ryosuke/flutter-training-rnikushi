---
name: flutter-training-review
description: flutter-training リポジトリのプルリクエストをレビューし、インラインコメントと優先度別のまとめコメントを日本語で投稿する。引数に `<owner/repo> <PR番号>` を受け取る。
---

# flutter-training-review

引数: `$ARGUMENTS`（`<owner/repo> <PR番号>` の形式）

引数で指定されたプルリクエストをレビューしてください。

## 作業手順

1. `CLAUDE.md` と `docs/ARCHITECTURE.md` を読み、プロジェクトの規約と設計方針を把握する
2. `gh pr view` で PR 本文と紐づく Issue を確認し、課題の要件を把握する
3. `gh pr diff` でコードの変更内容と行番号を把握する
4. 改善点・懸念点がある行に `mcp__github_inline_comment__create_inline_comment` でインラインコメントを追加する
   - 修正方針が明確な場合は積極的にsuggestionブロックを使う
5. `gh pr comment` でレビュー全体のまとめコメントを1件投稿する

## インラインコメントの書き方

- **結論を先に:** 冒頭の1行で指摘の要点を簡潔に述べる
- **理由と提案:** その後に判断理由・背景・具体的な修正案を説明する
- **指摘中心に:** 修正提案・バグの可能性・可読性の問題など改善点に絞る
- **ポジティブなフィードバックはインラインでは控えめに:** 特筆すべき優れた実装のみ言及する

## まとめコメントの構成

まとめコメントは以下の構成で投稿してください。

### 1. 優先度別フィードバック一覧（表形式）

以下の優先度基準で全指摘事項を分類し、表形式で一覧化してください。

| 優先度 | 基準 |
|--------|------|
| 🔴 Critical | バグ・セキュリティリスク・データ損失の恐れがあるもの |
| 🟠 High | 重大なパフォーマンス問題・設計上の欠陥（`docs/ARCHITECTURE.md` の依存方向・責務分担に反するもの） |
| 🟡 Medium | 保守性・可読性の問題・ベストプラクティス違反 |
| 🟢 Low | 軽微なスタイル・命名・コメントの改善提案 |

出力フォーマット：

| 優先度 | ファイル | 内容の要約 |
|--------|----------|------------|
| 🔴 Critical | `lib/foo.dart#L12` | 非同期処理の例外が握りつぶされている |
| 🟡 Medium | `lib/bar.dart#L34` | 変数名が処理内容を反映していない |

### 2. 対応推奨順

表の後に、対応すべき順番を番号付きリストで簡潔に示してください。

### 3. 全体所感

- 良かった点・PR全体へのポジティブな感想をまとめる
- 全体的な品質評価を一言で添える

## レビュー観点

### 全般

- CLAUDE.md のガイドラインに従っているか
- Issue に書かれた課題の要件を満たしているか
- コードの品質・ベストプラクティスに沿っているか
- バグ・セキュリティリスクがないか
- パフォーマンス上の懸念がないか
- 保守性・可読性は十分か

### 設計・アーキテクチャ（`docs/ARCHITECTURE.md` 準拠）

ドキュメントの方針から外れている箇所は、該当する節を示して指摘する。方針の変更が妥当な場合は、`docs/ARCHITECTURE.md` の更新も同じ PR に含まれているかを確認する。

- **レイヤーと依存方向**
  - 依存が UI → Domain ← Data の向きになっているか
  - Domain が Flutter・外部パッケージ（`yumemi_weather` など）・Data・UI に依存していないか
  - ViewModel が Repository を直接参照せず、UseCase を経由しているか
  - Screen が UseCase・Repository を直接参照していないか
  - 具象クラス（`XxxImpl`）を参照しているのが `lib/di/` だけか
- **ディレクトリ・命名**
  - ファイルが `domain/<feature>/`・`data/api/<feature>/`・`ui/screen/<feature>/` の決まった位置にあるか
  - interface が `abstract interface class`、実装が `<Interface名>Impl` になっているか
  - ViewModel のメソッド名が UI 操作名ではなく、処理内容を表しているか
- **状態管理・DI（Riverpod）**
  - Provider が `lib/di/` に interface 型で宣言されているか（ViewModel の `NotifierProvider` は ViewModel と同じファイル）
  - 外部 API のクライアントなど、テストで差し替えたい依存が Provider 経由で注入されているか
  - Screen が `ConsumerWidget` で、状態を `ref.watch`、操作を `ref.read(...notifier)` で扱っているか
  - `build` 内で直接 `ref.read` していないか、状態を持つインスタンスを `build` 内で生成していないか
- **エラーハンドリング**
  - RepositoryImpl が外部 API のレスポンスとエラーを `Result` / `AppError` にマッピングして返しているか（Domain の例外として throw し直していないか）
  - 外部パッケージのエラー型（`YumemiWeatherError` など）を RepositoryImpl の `on` 節付きの catch で受け、Domain に漏らしていないか（`Error` を catch していないか）
  - UseCaseImpl が例外の変換をせず、Repository の `Result` を返しているか
  - ViewModel・UI が `Result` / `AppError` を `switch` で網羅的に処理しているか（`default` や `_` で分岐を潰していないか）
  - `AppError` を追加した場合、RepositoryImpl のマッピングと UI のメッセージ（`AppErrorX.message`）の分岐が更新されているか
  - エラーを表示する画面では、表示中のデータとエラーを UiState の別のフィールドで持ち、ダイアログを閉じたら `error` を `null` に戻しているか
- **テスト**
  - UseCase に対するユニットテストがあり、Repository は本物、外部 API だけを Fake にしているか
  - ViewModel に対するユニットテストがあり、API の成功・失敗から UiState への変換と、リスナーへの通知を検証しているか
  - DTO の `toJson` / `fromJson` の変換と、想定外の JSON での例外をユニットテストで検証しているか
  - 依存の差し替えが `ProviderContainer.test(overrides: [...])` で行われているか
  - 正常系だけでなく、想定外のレスポンス・例外発生時の異常系もテストしているか
  - `Result` の検証に `isSuccess` / `isFailure<E>` を使っているか
  - 状態と UI の連携に依存する振る舞い（エラーダイアログの表示・再表示など）を、Screen の Widget テストで検証しているか

## その他

- フィードバックは日本語で行う
- PRをブロックしないこと（REQUEST_CHANGESは使わない）
