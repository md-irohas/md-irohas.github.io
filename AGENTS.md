# Instructions for Agents

このファイルでは、リポジトリ全体に適用されるエージェント向けの指示を記載します。


## プロジェクト概要

プロジェクトの概要については、`README.md` を参照してください。


## タスクコマンド

主なタスクのコマンドは Makefile に定義されています。

例：

- 新しい記事を作成する：
    - `make article KIND=travel SLUG=2026-01-01-travel-some-slug`
    - `make article KIND=photo SLUG=2026-01-01-photo-some-slug`
    - `make article KIND=camping SLUG=2026-01-01-camping-some-slug`
    - `make tech-article SLUG=2026-01-01-some-slug`
- サイトをビルドする：
    - `make build`
    - `make build-dev`


## 指示の優先順位

ファイルを編集する際は、次の順序で指示に従ってください。

1. 対象ファイルのディレクトリツリー内で最も近い `AGENTS.md`
2. その `AGENTS.md` から参照されている人間向けのガイドライン文書
3. リポジトリ全体に適用されるこの `AGENTS.md`

コンテンツ別の参照先は次のとおりです。

- ブログ：
    - エージェント向けの指示: `content/blog/AGENTS.md`
    - 執筆ガイドライン: `docs/content-guidelines/blog.md`
- 技術記事：
    - エージェント向けの指示: `content/tech/AGENTS.md`
    - 執筆ガイドライン: `docs/content-guidelines/tech.md`
- ギャラリー（予定）：
    - エージェント向けの指示: `content/gallery/AGENTS.md`
    - 執筆ガイドライン: `docs/content-guidelines/gallery.md`


## リポジトリ全体の注意事項

- 既存の文体と構成を維持してください。
- Front MatterやShortcodeの使用方法には一貫性を持たせてください。
- 必要がない限り、画像ファイルを読み込まないでください。
