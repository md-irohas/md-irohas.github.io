# Instructions for Agents

This file defines repository-wide instructions for agents.


## Project Overview

Read README.md for an overview of this project.


## Task Commands

Makefile provides commands for main tasks.

For example:

- Create new articles:
    - `make article KIND=trip SLUG=2026-01-01-trip-some-slug`
    - `make article KIND=tripphoto SLUG=2026-01-01-tripphoto-some-slug`
    - `make article KIND=camping SLUG=2026-01-01-camping-some-slug`
    - `make tech-article SLUG=2026-01-01-some-slug`
- Build a site:
    - `make build`
    - `make build-dev`


## Instruction Hierarchy

When editing files, follow instructions in this order:

1. The nearest `AGENTS.md` in the target directory tree.
2. Human-facing guideline documents referenced by that `AGENTS.md`.
3. This repository-wide `AGENTS.md`.

Content-Specific entry points are as follows:

- Blog:
    - Agent instructions: `content/blog/AGENTS.md`
    - Human guidelines: `docs/content-guidelines/blog.md`
- Tech (planned):
    - Add `content/tech/AGENTS.md`
    - Add `docs/content-guidelines/tech.md`
- Gallery (planned):
    - Add `content/gallery/AGENTS.md`
    - Add `docs/content-guidelines/gallery.md`


## Repository-Wide Cautions

- Preserve existing writing style and structure.
- Keep front matter and shortcode usage consistent.
- Avoid loading image files unless necessary.
- After editing files under `content/`, check if `make build-dev` passes.

