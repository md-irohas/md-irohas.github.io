# Instructions for Agents

Scope: `content/blog/`


## Required Reading

Before creating or editing blog content, read:

- `docs/content-guidelines/blog.md`


## Execution Rules

- Follow directory and slug rules defined in the guideline.
- Follow category-specific template, section, taxonomy, and tag rules.
- Do not invent new canonical category labels or tag naming conventions
  without explicit user request.
- Keep front matter format and shortcode style consistent with existing posts.
- Include all JPEG image files from the directory in the story and gallery sections.
  - Use the appropriate `class` attribute in figure shortcodes based on the image orientation:
    - Portrait: `w33`
    - Landscape: `w50`
    - Panorama: `w100`


## Validation Checklist

- [ ] Front matter is valid and consistent.
- [ ] Directory format and slug are correct.
- [ ] Category-specific rules are applied.
- [ ] `make build-dev` passes.

