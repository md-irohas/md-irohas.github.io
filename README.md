# mkt's sidenotes

This repository contains the source files for mkt's website (mkt's sidenotes).

URL: https://mkt-sidenotes.dev/


## Overview

- Title: mkt’s sidenotes
- URL: https://mkt-sidenotes.dev/
- Repository: https://github.com/md-irohas/md-irohas.github.io
- Platform: Cloudflare Pages
- Static Site Generator: Hugo
    - Hugo Theme: Blowfish (https://github.com/nunocoracao/blowfish)
- Languages: English and Japanese


## Requirements

- Hugo
- Blowfish
- DevContainer (optional)
- ImageMagick and ExifTool (required for image processing)


## Directory Structure

Directory structure follows Hugo's conventions.

The main content directory structure (under `content/`) is as follows:

```
content/
    |- about/       About page
    |- blog/        Blog posts
    |   |- <YYYY-mm-dd>-<category>-<slug>/
    |- gallery/     Photo gallery
    |   |- <YYYY>/
    |- tech/        Tech posts (links to external platforms)
        |- <YYYY-mm-dd>-<slug>/
```


## External Resources

The following external resources are used by this website.

- Bootstrap Icons: https://icons.getbootstrap.com/
    - SVG files in `assets/icons/` are from Bootstrap Icons ([MIT License](assets/icons/LICENSE))

