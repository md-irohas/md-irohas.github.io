# Blog Content Guidelines

このファイルは、`content/blog/`に置く記事のガイドラインです。


## 概要

`content/blog/`では、旅行・写真・キャンプ関連のブログ記事を記載します。
なお、技術系のブログ記事は`content/tech/`で管理します。

記事は、英語版と日本語版を作成します。

記事のPathのフォーマットは以下の通りです。

```
content/blog/<YYYY-mm-dd>-<kind>-<slug>/
```

- `<YYYY-mm-dd>`: 記事の作成日。
- `<kind>`: 記事の種類（`trip` / `tripphoto` / `camping`）。種類別のポリシーは後述。
- `<slug>`: タイトルに対応する文字列。


## 種類別のポリシー

### trip

旅行全体のまとめ記事です。
基本的には複数の`tripphoto`の記事をまとめます。

以下のテンプレートファイルを使用します。

- English: `archetypes/trip.en.md`
- Japanese: `archetypes/trip.ja.md`

Front Matterは以下の通りです。

- title:
    - English: `Trip Recap: <site-name> (Month, Year)`
    - Japanese: `旅の記録: <場所名>（〜年〜月）`
- date: 記事の作成日（自動挿入）
- categories:
    - English: `Blog (Trip Recap)`
    - Japanese: `ブログ（旅の記録）`
- tags:
    - English: `Trip Recap`, `<Prefecture-1>`, `<Prefecture-2>`, ...
    - Japanese: `旅行`, `<県名1>`, `<県名2>`, ...
- isCJKLanguage:
    - English: false
    - Japanese: true
- description: 記事の概要をテンプレートに従って記述。
- summary: 観光した場所の一覧をテンプレートに従って記述。
- draft: 下書きのうちはtrue。

記事のセクションは概ね以下の通りです。

- Story / ストーリー
    - 訪問日時・場所のイントロ
    - 全体のGoogle My Maps
- Timeline / タイムライン
    - 各記事へのリンク
    - 個別記事に入れきれなかった場所の補足
    - 画像、マップ、リンク
- Gallery / ギャラリー
- Map / マップ
    - Google Map または Google My Map
- Related Articles / 関連記事
- Change History / 編集履歴


### tripphoto

観光地ごとの写真記事です。
1スポット（または近いスポット群）単位で記録します。

以下のテンプレートファイルを使用します。

- English: `archetypes/tripphoto.en.md`
- Japanese: `archetypes/tripphoto.ja.md`

Front Matterは以下の通りです。

- title:
    - English: `Trip Photo: <site-name> (Month, Year)`
    - Japanese: `旅の写真: <場所名>（〜年〜月）`
- date: 記事の作成日（自動挿入）
- categories:
    - English: `Blog (Trip Photo)`
    - Japanese: `ブログ（旅の写真）`
- tags:
    - English: `Trip`, `Photo`, `<Prefecture>`, `<Kind-of-Place>`, ...
        - 都道府県名の "Prefecture" はタグ文字列に含めない
    - Japanese: `旅行`, `写真`, `<県名>`, `<場所の種類>`, ...
- isCJKLanguage:
    - English: false
    - Japanese: true
- description: 記事の概要をテンプレートに従って記述。
- summary: 観光した場所の一覧をテンプレートに従って記述。
- draft: 下書きのうちはtrue。
- googlePhotoUrl: Google Photosへのリンクです。
- googleDriveUrl: 画像等のデータを保存するGoogle Driveへのリンクです。

記事のセクションは概ね以下の通りです。

- Story / ストーリー
    - 訪問日時・場所の紹介
    - おすすめスポット
    - 画像、マップ、リンク
- Gallery / ギャラリー
    - 機材ごとにまとめる（例: `iPhone 12 mini`, `α6500`）
    - 写真のライセンスは`CC BY-NC-SA 4.0`
        - Creative Commonsは一度設定すると撤回できないので注意
    - 画像は圧縮済・署名入り・数百KB程度
- Map / マップ
    - Google Map（場所ごと）
    - Google My Map（場所一覧と写真の紐づけ）
- Change History / 編集履歴

tagに設定する「場所の種類（Kind-of-Place）」は以下の通りです。

- 自然系:
    - `Sea`: 海
    - `Sky`: 空
    - `Mountain`: 山
    - `Forest`: 森
    - `Lake`: 湖
    - `Cave`: 洞窟
    - `Grassland`: 草原
    - `Sand Dunes`: 砂丘
    - `Waterfall`: 滝
    - `Starry Night`: 星空
- 建物系:
    - `Lighthouse`: 灯台
    - `Shrine`: 神社
    - `Temple`: 寺院
    - `Park`: 公園
    - `Lookout`: 展望台
    - `Scenic Road`: 景観道路
    - `Tourist Area`: 観光エリア
    - `Historic Spot`: 史跡
    - `Service Area`: サービスエリア
- 施設:
    - `Aquarium`: 水族館
    - `Museum`: 博物館
    - `Zoo`: 動物園


### camping

キャンプ記事です。キャンプ体験と写真をセットで記録します。

以下のテンプレートファイルを使用します。

- English: `archetypes/camping.en.md`
- Japanese: `archetypes/camping.ja.md`

Front Matterは以下の通りです。

- title:
    - English: `Camping: <site-name> (Month, Year)`
    - Japanese: `キャンプ: <場所名>（〜年〜月）`
- date: 記事の作成日（自動挿入）
- categories:
    - English: `Blog (Camping)`
    - Japanese: `ブログ（キャンプ）`
- tags:
    - English: `Camping`, `Photo`, `<Prefecture>`, `<Kind-of-Camp-Site>`, `<Kind-of-Place>`, ...
    - Japanese: `キャンプ`, `写真`, `<県名>`, `<キャンプ場の種類>`, `<場所の種類>`, ...
- isCJKLanguage:
    - English: false
    - Japanese: true
- description: 記事の概要をテンプレートに従って記述。
- summary: 観光した場所の一覧をテンプレートに従って記述。
- draft: 下書きのうちはtrue。
- googlePhotoUrl: Google Photosへのリンクです。
- googleDriveUrl: 画像等のデータを保存するGoogle Driveへのリンクです。

記事のセクションは概ね以下の通りです。

- Story / ストーリー
    - 訪問日時、場所、設備の紹介
    - おすすめポイント
    - 画像、マップ、リンク
- Gallery / ギャラリー
    - 機材ごとにまとめる（例: `iPhone 12 mini`, `α6500`）
    - 写真のライセンスは`CC BY-NC-SA 4.0`
        - Creative Commonsは一度設定すると撤回できないので注意
    - 画像は圧縮済・数百KB程度
- Map / マップ
    - Google Map
- Change History / 編集履歴

tagに設定する「キャンプ場の種類（Kind-of-Camp-Site）」は以下の通りです。

- キャンプサイトの種類:
    - `林間キャンプ`: Forest Camping
    - `湖畔キャンプ`: Lakeside Camping
    - `海辺キャンプ`: Beach Camping
    - `高原キャンプ`: Highland Camping
    - `草原キャンプ`: Meadow Camping
- その他:
    - `tripphoto`の「場所の種類（Kind-of-Place）」を合わせて使用。

