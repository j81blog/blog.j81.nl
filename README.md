# blog.j81.nl

Personal tech blog by John Billekens — Citrix · VMware · Networking.
Built with [Hugo](https://gohugo.io/) and the [Stack theme](https://github.com/CaiJimmy/hugo-theme-stack).

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Hugo Extended | ≥ 0.161 | `winget install Hugo.Hugo.Extended` |
| Git | any | [git-scm.com](https://git-scm.com) |
| pandoc | any | `winget install JohnMacFarlane.Pandoc` — only needed if re-running the WordPress import |

## Local development

```powershell
# Clone (includes the Stack theme submodule)
git clone --recurse-submodules https://github.com/JohnBillekens/blog.j81.nl

# Start the dev server — live reload on save
hugo server

# Open http://localhost:1313
```

> Images reference `/wp-content/uploads/...` (root-relative). They load correctly on
> the live site. Locally they will 404 unless you copy `static/wp-content/` to your
> checkout (it is gitignored — see below).

### Useful server flags

```powershell
hugo server --buildDrafts        # include draft posts
hugo server --buildFuture        # include future-dated posts
hugo server --disableFastRender  # full rebuild on every change (slower but safer)
```

## Writing a new post

```powershell
# Blog post
hugo new content/posts/YYYY-MM-DD-my-post-title.md

# HowTo guide
hugo new content/howto/YYYY-MM-DD-howto-my-guide.md
```

Edit the generated file in `content/posts/` or `content/howto/`. Set `draft: false`
(or remove the `draft` key) when ready to publish. Push to `main` — GitHub Actions
handles the rest.

### Front matter reference

```yaml
---
title: "My Post Title"
date: 2026-05-19T10:00:00Z
categories:
  - "Citrix"
tags:
  - "NetScaler"
  - "Certificate"
series:
  - "NetScaler Series"   # optional — links related posts together
draft: false
---
```

## Deploying

Push to `main`. GitHub Actions (`.github/workflows/deploy.yml`) will:
1. Build with `hugo --minify`
2. Push the output to the `gh-pages` branch → GitHub Pages serves it

The mijn.host SFTP deploy step is present in the workflow but commented out.
Uncomment it and add the three GitHub Secrets (`MIJNHOST_SERVER`, `MIJNHOST_USER`,
`MIJNHOST_PASS`) when ready to deploy to production.

## Repo structure

```
blog.j81.nl/
├── assets/scss/custom.scss      # Color palette, Montserrat font, tag chip styles
├── content/
│   ├── posts/                   # Blog posts (79 migrated from WordPress)
│   ├── howto/                   # HowTo guides (8 migrated from WordPress)
│   ├── about/_index.md          # About page → /about/
│   ├── contact/_index.md        # Contact page → /contact/
│   ├── pages/                   # Other WordPress pages (welcome, donate, etc.)
│   ├── archives/_index.md       # Archives widget page
│   └── search/_index.md         # Search page
├── layouts/
│   ├── _partials/
│   │   ├── head/custom.html     # Injects cookie consent into <head>
│   │   └── comments/provider/giscus.html
│   └── partials/cookieconsent.html
├── static/
│   ├── fonts/montserrat/        # Self-hosted Montserrat woff2 files
│   ├── wp-content/uploads/      # WordPress media (196 MB — gitignored, local only)
│   ├── js/cookieconsent.umd.js  # orestbida/cookieconsent v3.1.0 (self-hosted)
│   └── css/cookieconsent.css
├── themes/stack/                # Hugo Stack theme (git submodule)
├── scripts/
│   └── process-wp-import.ps1   # WordPress XML → Hugo Markdown converter
├── working_data/                # WordPress export + full backup (gitignored, local only)
└── hugo.yaml                    # Site configuration
```

## WordPress import (reference only)

The content in `content/posts/`, `content/howto/`, `content/about/`, and `content/contact/`
was generated from the WordPress XML export by running:

```powershell
scripts\process-wp-import.ps1
```

This script uses pandoc to convert HTML → Markdown, rewrites image URLs to root-relative
paths, routes HowTo pages to the correct section, and adds `aliases` front matter for
all original WordPress URLs. You normally do not need to run this again.

To re-run (e.g. after a fresh clone without committed content):

```powershell
# Requires pandoc on PATH and the WordPress XML in working_data/
scripts\process-wp-import.ps1
```

## Giscus comments

Comments use [Giscus](https://giscus.app) (GitHub Discussions). To activate:

1. Enable Discussions on this GitHub repo
2. Go to [giscus.app](https://giscus.app), select the repo, copy `data-repo-id` and `data-category-id`
3. Add to `hugo.yaml`:

```yaml
params:
  comments:
    enabled: true
    provider: giscus
    giscus:
      repo: JohnBillekens/blog.j81.nl
      repoID: "YOUR_REPO_ID"
      category: "Announcements"
      categoryID: "YOUR_CATEGORY_ID"
```

Comments only load after a visitor accepts the functional cookie category (cookie consent bar).
