---
name: draft-japanese-travel-photo-article
description: >-
  Expand Japanese rough notes, links, and local photo files already placed in
  this Hugo site's content/blog index.ja.md into a polished Japanese travel,
  photo, or camping article. Use when Codex is explicitly asked to read the
  user's Japanese notes in index.ja.md after the article was created by make,
  write only the Japanese article, preserve local content/blog conventions, and
  leave index.en.md for a later English-version skill.
---


# Draft Japanese Travel Photo Article


## Purpose

Turn the user's notes in `index.ja.md` into the Japanese version of a
`content/blog/` article. Keep this skill focused on the author's Japanese draft
step; do not draft or translate `index.en.md`.


## Required Reading

Before editing, read the project sources of truth instead of relying on copied
rules in this skill:

- `content/blog/AGENTS.md`
- `docs/content-guidelines/blog.md`
- The matching Japanese archetype under `archetypes/`
- One or two recent Japanese examples under `content/blog/`


## Workflow

1. Confirm the article directory and files already exist from the repository's
   `make article` workflow.
2. Read `index.ja.md` as the source notes and target draft.
3. Use local filenames, dimensions, EXIF, and only necessary image inspection to
   organize photos and assign figure/gallery classes.
4. Expand notes into natural Japanese prose while preserving the user's facts,
   links, maps, intended structure, and useful wording.
5. Edit only `index.ja.md` unless the user explicitly asks otherwise.
6. Do not invent personal experiences, route details, exact times, weather,
   costs, official facts, or photo subjects. Ask or leave TODOs when facts are
   missing.
7. Validate front matter, shortcode syntax, image references, and gallery
   completeness according to `docs/content-guidelines/blog.md`.
8. Run `make build-dev` after content edits when feasible.


## Final Response

Report changed files, validation/build result, JPEGs used only in Gallery, and
remaining TODOs or missing user details.
