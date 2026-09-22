# Tech Blog Content Guidelines

`content/tech/`の記事の執筆ガイドラインです。

## 概要

`content/tech/`には、技術関連のブログ記事を記載します。
なお、旅行や写真のブログ記事は`content/blog/`に配置します。

記事は、原則として英語版と日本語版を作成します。

## ファイルの構成

記事のPathのフォーマットは以下の通りです。

```
content/tech/<YYYY-mm-dd>-<slug>/
```

- `<YYYY-mm-dd>`: 記事の作成日。
- `<slug>`: タイトルに対応する文字列。

ディレクトリ内には、以下のMarkdownファイルとページ内で使用する画像ファイル等を配置します。

- 日本語版: `index.ja.md`
- 英語版: `index.en.md`

## 外部サイトの利用

技術系の記事は、以下の外部サイトへ転載します。

- 日本語記事: [Zenn](https://zenn.dev/)
- 英語記事: [dev.to](https://dev.to/)

## ポリシー

### テンプレートファイル

以下のテンプレートファイルを使用します。

- 日本語: `archetypes/tech.ja.md`
- 英語: `archetypes/tech.en.md`

### 構成

特にフォーマットや記載項目は指定してませんが、以下の項目を入れるようにします。

- 検証環境
    - OSやソフトウェアのバージョン
- 編集履歴 / Change History

### 文章スタイル

- 技術的に正確な文章を目指します。ただし、個人の技術ブログなので、正確さよりもわかりやすさ、網羅的な文書よりも簡易的な事例を目指します。
- 口語的な記述でOKです。

### タグ

タグ（tags）の例は以下の通りです。必要に応じて追加します。

- Linux
- Command / コマンド
- My Failure / やらかし
- Monitoring / 可視化
- Visualization / 可視化
- `<ソフトウェア名>`
