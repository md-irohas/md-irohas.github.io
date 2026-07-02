---
name: write-english-travel-photo-article
description: >-
  Write or update this Hugo site's English travel, photo, or camping article in
  index.en.md from the reviewed Japanese article in index.ja.md. Use when Codex
  is explicitly asked to perform the English-version step after the Japanese
  article has been drafted and revised, adapting facts and structure into
  natural English while preserving local content/blog conventions and leaving
  index.ja.md unchanged.
---


# Write English Travel Photo Article


## Purpose

Write `index.en.md` from the reviewed Japanese source in `index.ja.md`. Treat
the Japanese article as the factual source and produce natural English, not a
literal line-by-line translation.


## Required Reading

Before editing, read the project sources of truth instead of relying on copied
rules in this skill:

- `content/blog/AGENTS.md`
- `docs/content-guidelines/blog.md`
- The matching English archetype under `archetypes/`
- The finalized or user-reviewed `index.ja.md`
- One or two recent English examples under `content/blog/`


## Workflow

1. Confirm `index.ja.md` is reviewed enough to use as the source. If it still
   looks like rough notes or contains blocking TODOs, ask before continuing.
2. Read `index.en.md` as the target scaffold and preserve valid generated front
   matter, params, and shortcode structure.
3. Adapt the Japanese article's facts, order, places, maps, links, images,
   captions, and gallery structure into English.
4. Edit only `index.en.md` unless the user explicitly asks otherwise.
5. Do not add new memories, route details, official facts, or photo descriptions
   beyond the reviewed Japanese source and verifiable local context.
6. Validate front matter, shortcode syntax, image references, bilingual fact
   alignment, and gallery completeness according to
   `docs/content-guidelines/blog.md`.
7. Run `make build-dev` after content edits when feasible.


## Final Response

Report changed files, validation/build result, Japanese TODOs that blocked
drafting, and any intentional differences from `index.ja.md`.
