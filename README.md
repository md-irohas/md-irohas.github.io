# mkt's sidenotes

This repository contains source files for mkt's website (mkt's sidenotes).

URL: https://mkt-sidenotes.dev/


## Overview

- Title: mkt’s sidenotes
- URL: https://mkt-sidenotes.dev/
- Repository: https://github.com/md-irohas/md-irohas.github.io
- Platform: Cloudflare Pages
- Static Site Generator: Hugo
    - Hugo's Theme: Blowfish (https://github.com/nunocoracao/blowfish)
- Languages: English and Japanese


## Requirements

- Hugo
- Blowfish
- (Optional) DevContainer
- (Required for image processing) ImageMagick, ExifTool


## Directory Structure

Directory structure follows Hugo's conventions.

A main content directory structure (under `content/`) is as follows:

```
content/
    |- about/       About page
    |- blog/        Blog posts
    |   |- <YYYY-mm-dd>-<category>-<slug>/
    |- gallery/     Photo gallery
    |   |- <YYYY>/
    |- tech/        Tech posts (Links to external platforms)
        |- <YYYY-mm-dd>-<slug>/
```


## External Resources

The following are external resources used in this website.

- Bootstrap Icons: https://icons.getbootstrap.com/
    - SVG files in `assets/icons/` are from Bootstrap Icons ([MIT License](assets/icons/LICENSE))

