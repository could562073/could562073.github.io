# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Commands

```bash
# Local dev server with live reload
hugo server -D

# Production build (same as CI)
hugo --minify

# New post scaffold
hugo new post/<YYYY-MM-DD-slug>/index.md
```

## Deployment

Pushing to `master` triggers `.github/workflows/deploy.yml`, which builds with `hugo --minify` and deploys the `public/` output to the `gh-pages` branch. No manual deploy step needed.

## Architecture

This is a Hugo static blog using the `hugo-theme-cleanwhite` theme (git submodule at `themes/hugo-theme-cleanwhite`). Site config lives in `hugo.toml`.

**Content structure:**
- `content/post/<YYYY-MM-DD-title>/index.md` — each post is a folder containing `index.md` and any referenced images
- `content/about/` — bilingual about page (`index.md` + `index-zh.md`)
- `archetypes/default.md` — scaffold template for new posts

**Post frontmatter** uses TOML delimiters (`+++`):
```toml
+++
title = "Post Title"
date = 2026-05-11
draft = false
tags = ["LeetCode"]
categories = ["LeetCode"]
+++
```

**Math rendering** is enabled via the passthrough extension: use `\(...\)` for inline and `\[...\]` or `$$...$$` for block math.

**Syntax highlighting** uses the Dracula theme. Table of contents renders heading levels 1–2.

Algolia search is configured in `hugo.toml` but currently disabled (empty keys). Disqus, page-view counter, and reward features are also disabled.
