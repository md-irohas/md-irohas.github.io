# Instructions for Codex and GitHub Copilot

This file defines operating guidelines for agents such as Codex and GitHub
Copilot working in this repository.


## Project Overview

This repository contains the source files of my personal website including my
projects and blogs. The overview of this website is as follows:

- Site generator: Hugo
- Hugo theme: Blowfish (under `themes/blowfish`,
  https://github.com/nunocoracao/blowfish).
- Content languages: English and Japanese
- Website content: `content/`


## Directory Structure

This repository follows Hugo's directory structure conventions.

A main content directory structure (under `content/`) is as follows:

- `content/`:
    - `/about/`: Self-introduction page
    - `/blog/`: Blog articles on travel and photos
        - `<YYYY-mm-dd>-<kind>-<slug>/`
    - `/gallery/`: Photo galleries by year
        - `<YYYY>/`
    - `/tech/`: Blog articles on tech
        - `<YYYY-mm-dd>-<slug>/`: Mainly external links to dev.to (en) and
          zenn.dev (ja)


## Tasks

Makefile provides commands for main tasks:

- Create new articles:
    - `make article KIND=trip SLUG=2026-01-01-trip-some-slug`
    - `make article KIND=tripphoto SLUG=2026-01-01-tripphoto-some-slug`
    - `make article KIND=camping SLUG=2026-01-01-camping-some-slug`
    - `make tech-article SLUG=2026-01-01-some-slug`
- Build a site:
    - `make build` (for production)
    - `make build-dev` (for development)
- Run a local development server:
    - `make server` (for production content)
    - `make server-dev`


## Instructions and Cautions

- Preserve the existing writing style and structure when editing. Template
  markdown files are located under `archetypes/`.
- Keep front matter and shortcode usage consistent.
- This repository contains many images, so avoid loading image files unless
  necessary.
- After editing files, check if `make build-dev` passes.


