---
name: make-note-post
description: >-
  content/blog/**/index.ja.mdの日本語記事を、noteへ転載するための原稿案を作成します。
---

# note投稿案の作成

`content/blog/**/index.ja.md`の日本語記事を、noteへ転載するための原稿案を作成します。
作成した原稿案はチャットに出力し、元の記事は変更しないでください。

## 資料

原稿案の作成にあたっては以下の資料を参考にしてください。

- Codexへの指示: `content/blog/AGENTS.md`
- 原稿執筆のガイドライン: `docs/content-guidelines/blog.md`
- 対象記事: `content/blog/*/index.ja.md`

原則として画像の内容は確認せず、ファイル名とキャプションから判断してください。

## 手順

1. 対象の`index.ja.md`がレビュー済みであることを確認します。TODOなどが残っている場合はユーザに確認してください。
2. 変換が問題なく実行できるかを確認します。確認事項がある場合はユーザに確認してください。
3. 問題がなければ、出力テンプレート、変換ルールに従って、note用の原稿を作成し、チャット欄に出力してください。

## 変換ルール

- 文章は書き換え、要約、加筆、翻訳、事実確認をせず、すべてのセクションと順序を維持します。
- TOML front matter、`note-link`、HTMLコメント、`<br>`、レイアウト用shortcodeは削除します。
- `figure`は同じ位置で次の形式に変換します。HTMLコメント内のものは含めません。

  ```markdown
  > 【note作業：画像を挿入】
  > ファイル: `IMAGE.jpg`
  > キャプション: 元のキャプション
  ```

- `google-maps-2`はURLを省略せず、同じ位置で次の形式に変換します。

  ```markdown
  > 【note作業：Google マップを埋め込み】
  > URL: https://...
  ```

- `alert`の内容はMarkdownの引用に変換します。
- `/ja/blog/...`リンクは`https://mkt-sidenotes.dev/ja/blog/...`に変換し、外部リンクはそのまま使用します。
- 「ギャラリー」は端末名や`gallery`内の画像を除き、front matterの`googlePhotoUrl`と`googleDriveUrl`を使って次の形式に置き換えます。URLがない場合は手作業用のマーカーを入れます。

  ```markdown
  ## ギャラリー

  ライセンス: **[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ja)**

  ### Google Photos

  {{GOOGLE_PHOTOS_URL}}

  ### Google Drive

  {{GOOGLE_DRIVE_URL}}
  ```

- 未対応の有効なshortcodeは削除せず、ユーザに確認します。

## 出力テンプレート

記事のテンプレートは以下の通りです。

```markdown
# Title
{{NOTE_TITLE}}

# Body

この記事は、個人の旅行や写真の記録です。
筆者（mkt）は旅行や写真に詳しいわけではありませんので、個人の思い出としてゆるく参考にしてもらえると嬉しいです。

前回の投稿: {{PREVIOUS_NOTE_URL}}

> 【note作業：ここに目次を挿入】

{{CONVERTED_ARTICLE_BODY}}

個人ブログ:
{{CANONICAL_BLOG_URL}}
```

- `{{NOTE_TITLE}}`: 記事のタイトル。
- `{{PREVIOUS_NOTE_URL}}`: ユーザ指定のURLを使用します。指定がない場合は、front matterの日付が対象記事より前で最も新しい日本語記事の、有効かつコメント化されていない`note-link`を使用します。見つからない場合は空白にします。
- `{{CONVERTED_ARTICLE_BODY}}`: 記事の本文。
- `{{CANONICAL_BLOG_URL}}`: 対象記事のディレクトリ名を使い、`https://mkt-sidenotes.dev/ja/blog/<記事ディレクトリ名>/`形式のURLを作成します。

出力前に、Hugoのshortcode、HTMLコメント、相対リンク、未置換のプレースホルダーが残っていないことを確認してください。
