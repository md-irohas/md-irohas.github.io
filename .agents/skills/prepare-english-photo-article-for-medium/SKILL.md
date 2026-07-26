---
name: prepare-english-photo-article-for-medium
description: >-
  Prepare a reviewed English Hugo photo article under content/blog/**/index.en.md
  for manual reposting to the Medium publishing service at https://medium.com/.
  Use when Codex is asked to convert an English photo or legacy tripphoto post
  into a copy-paste-ready Medium title and body in the chat, using the bundled
  Medium template, converting Hugo shortcodes and repository-relative links,
  and leaving explicit manual markers for images and maps. Do not use for
  travel recap or camping posts.
---

# Prepare English Photo Article for Medium

## Purpose

Convert one reviewed English `photo` or legacy `tripphoto` article into a
copy-paste-ready title and body for the Web publishing service Medium
(`https://medium.com/`). Return the result in the chat without creating an
export file or editing the source article.

Throughout this skill, **the Medium service** means the Web publishing service
at `https://medium.com/`, not the adjective "medium."

## Required Reading

Before preparing the repost:

- Resolve `content/blog/AGENTS.md`, `docs/content-guidelines/blog.md`, and the
  selected article's `index.en.md` relative to the repository root, then read
  them.
- Resolve `./assets/medium-photo-template.md` relative to the directory
  containing this `SKILL.md`, not the repository root. Read that template
  completely and use it as the output structure.

Do not inspect image contents. The source filename and figure caption are
sufficient for this task.

## Workflow

1. Confirm the target is an English `photo` or legacy `tripphoto` article.
   Stop and explain the scope mismatch for `travel`, `trip`, or `camping`.
2. Treat the reviewed `index.en.md` as the factual source. Do not rewrite,
   summarize, embellish, translate, or fact-check its prose unless asked.
3. Extract the exact front matter `title`, including its emoji, and keep it
   separate from the Medium body.
4. Derive the canonical blog URL from the production base URL, the English
   language path, and the article directory name.
5. Resolve the previous post on the Medium service in this order:
   - Use a URL explicitly supplied by the user.
   - Otherwise, find the latest earlier English blog article by front matter
     date that has a real, uncommented `medium-link` URL.
   - If no reliable URL exists, insert a visible manual marker. Never invent a
     Medium URL or use a commented placeholder ending in `...`.
6. Convert the source content according to the rules below.
7. Fill every placeholder in the skill-relative
   `./assets/medium-photo-template.md`.
8. Validate the result and return it in the chat. Do not write any output file.

## Conversion Rules

- Expand the disclaimer using the exact English text in the template, even
  when an older source article does not contain `blog-disclaimer`.
- Copy the content of `## Story`, including its order and subheadings.
- Remove TOML front matter, the source `medium-link`, HTML comments, `<br>`
  tags, and layout-only shortcode wrappers.
- Convert every active `figure` shortcode in the Story into a visible marker at
  the same position:

  ```markdown
  > [Medium task: Insert image]
  > File: `IMAGE.jpg`
  > Caption: Original caption
  ```

- Do not include figures that exist only inside HTML comments.
- Convert every active `google-maps-2` shortcode into a visible marker at the
  same position and preserve its complete URL:

  ```markdown
  > [Medium task: Embed Google Map]
  > URL: https://...
  ```

- Convert `alert` content to a Markdown blockquote while preserving its text.
- Convert repository-relative `/blog/...` links to absolute
  `https://mkt-sidenotes.dev/blog/...` links. Keep external links unchanged.
- Do not reproduce device headings, `gallery` image grids, or individual
  gallery images. Build the Medium Gallery only from `googlePhotoUrl`,
  `googleDriveUrl`, and the fixed license text in the template.
- Copy the content of `## Map`, preserving its headings and notes, while
  converting each map shortcode to the manual marker above.
- Copy `## Change History` exactly except for shortcode or HTML cleanup.
- Replace any unsupported active shortcode with a visible
  `[Medium task: Unsupported shortcode ...]` marker and report it in the
  checklist. Never silently discard unknown active content.

## Chat Output

Return these items in order:

1. A copyable block containing only the exact Medium title.
2. A single copyable Markdown artifact containing only the Medium body.
3. A concise checklist outside the body with:
   - The number and filenames of image insertions.
   - The number of Google Map insertions.
   - Whether the previous Medium URL was supplied, inferred, or unresolved.
   - Missing Gallery URLs or unsupported shortcodes.

When writing blocks are available, use a `standard` writing block for the title
and a `document` writing block for the body. Otherwise, use separate fenced
Markdown blocks. Do not put explanations, the title, or the checklist inside
the Medium body.

## Validation

Before returning the result, confirm:

- The title matches front matter exactly.
- Story figure and map marker counts match the active source shortcodes in the
  corresponding sections.
- No TOML front matter, Hugo shortcode syntax, HTML comment, or relative
  `/blog/` link remains.
- Google Photos, Google Drive, canonical blog, and license URLs are present or
  visibly marked unresolved.
- `Story`, `Gallery`, `Map`, and `Change History` occur once and in the template
  order.
- The source repository files remain unchanged.
