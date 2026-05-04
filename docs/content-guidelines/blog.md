# Travel & Photo Blog Content Guidelines

`content/blog/`の記事のガイドラインです。


## 概要

`content/blog/`には、旅行・写真・キャンプ関連のブログ記事を記載します。
なお、技術系のブログ記事は`content/tech/`に記載します。

記事は、英語版と日本語版を作成します。


## ファイルの構成

記事のPathのフォーマットは以下の通りです。

```
content/blog/<YYYY-mm-dd>-<kind>-<slug>/
```

- `<YYYY-mm-dd>`: 記事の作成日。
- `<kind>`: 記事の種類（`travel` / `photo` / `camping`）。
    - 2026年3月以前の記事では、`trip` / `tripphoto` / `camping`を使用していました。
- `<slug>`: タイトルに対応する文字列。

ディレクトリ内には、以下のMarkdownファイルとページ内で使用する画像（JPEG）ファイルを配置します。

- index.ja.md: 日本語版
- index.en.md: 英語版


## 種類別のポリシー

### travel （旧 trip）

旅行全体のまとめ記事です。

基本的には複数の`photo`の記事（既存記事では`tripphoto`）をまとめます。

以下のテンプレートファイルを使用します。

- 英語: `archetypes/travel.en.md` （旧 `archetypes/trip.en.md`）
- 日本語: `archetypes/travel.ja.md` （旧 `archetypes/trip.ja.md`）

記事のセクションは以下の通りです。

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

タグ（tags）は以下の通りです。

- `Trip Recap` / `旅の記録`
- `<Prefecture>` / `<都道府県>`
  - 英語では、Prefectureにような都道府県にあたる単語は無（e.g. `Nagano`）。
  - 日本語では、都道府県の文字は有（e.g. `長野県`）。


### photo （旧 tripphoto）

写真記事です。

1スポット（または近いスポット群）単位で記録します。

以下のテンプレートファイルを使用します。

- 英語: `archetypes/photo.en.md` （旧 `archetypes/tripphoto.en.md`）
- 日本語: `archetypes/photo.ja.md` （旧 `archetypes/tripphoto.ja.md`）

記事のセクションは以下の通りです。

- Story / ストーリー
    - 訪問日時・場所の紹介
    - おすすめスポット
    - 画像、マップ、リンク
- Gallery / ギャラリー
    - 機材ごとにまとめる（例: `iPhone 12 mini`, `α6500`）
    - 写真のライセンスは`CC BY-NC-SA 4.0`
        - Creative Commonsは一度設定すると撤回できないので注意。
    - 画像は圧縮済、右下に署名入り、ファイルサイズは数百KB程度。
- Map / マップ
    - Google Map（場所ごと）
    - Google My Map（場所一覧と写真の紐づけ）
- Change History / 編集履歴

タグ（tags）は以下の通りです。

- `Trip` / `旅行`
- `Photo` / `写真`
- `<Prefecture>` / `<都道府県>`
  - travelの`<Prefecture>`タグと同様。
- `<Kind-of-Place>` / `<場所の種類>`
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

キャンプ記事です。

キャンプ体験と写真をセットで記録します。

以下のテンプレートファイルを使用します。

- 英語: `archetypes/camping.en.md`
- 日本語: `archetypes/camping.ja.md`

記事のセクションは以下の通りです。

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

タグ（tags）は以下の通りです。

- `Camping` / `キャンプ`
- `Photo` / `写真`
- `<Prefecture>` / `<都道府県>`
  - travelの`<Prefecture>`タグと同様。
- `<Kind-of-Place>` / `<場所の種類>`
    - `林間キャンプ`: Forest Camping
    - `湖畔キャンプ`: Lakeside Camping
    - `海辺キャンプ`: Beach Camping
    - `高原キャンプ`: Highland Camping
    - `草原キャンプ`: Meadow Camping
    - その他:
        - `photo`の「場所の種類（Kind-of-Place）」のタグを合わせて使用。

