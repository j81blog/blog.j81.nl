# blog.j81.nl

Personal tech blog by John Billekens — Citrix · VMware · Networking.
Built with [Hugo](https://gohugo.io/) and the [Blowfish theme](https://blowfish.page/).

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Hugo Extended | ≥ 0.161 | `winget install Hugo.Hugo.Extended` |
| Git | any | [git-scm.com](https://git-scm.com) |
| pandoc | any | `winget install JohnMacFarlane.Pandoc` — only needed if re-running the WordPress import |

## Local development

```powershell
# Clone (includes the Blowfish theme submodule)
git clone --recurse-submodules https://github.com/j81blog/blog.j81.nl

# Start the dev server — live reload on save
hugo server

# Open http://localhost:1313
```

### Useful server flags

```powershell
hugo server --buildDrafts        # include draft posts
hugo server --buildFuture        # include future-dated posts
hugo server --disableFastRender  # full rebuild on every change (slower but safer)
```

## Writing a new post

### 1. Create the post file

```powershell
# Blog post
hugo new content/posts/YYYY-MM-DD-my-post-title/index.md

# HowTo guide
hugo new content/howto/YYYY-MM-DD-howto-my-guide/index.md
```

Using a **folder** (`post-name/index.md`) instead of a single file is the recommended
approach — it lets you store images right next to the post (see below).

### 2. Front matter reference

```yaml
---
title: "My Post Title"
date: 2026-06-06T10:00:00Z
categories:
  - "Citrix"
tags:
  - "NetScaler"
  - "Certificate"
series:
  - "NetScaler Series"   # optional — links related posts together
featureimage: hero.png   # optional — hero/banner image (see Images below)
draft: false
---
```

For **HowTo** guides, also add a `group` parameter so the guide appears under the
correct group heading on the `/howto/` index page:

```yaml
group: "NetScaler"   # groups: NetScaler | Citrix FAS | Windows | (or any new name)
```

Set `draft: false` (or remove the `draft` key) when ready to publish. Push to `main` —
GitHub Actions handles the rest.

## Images in new posts

### Page bundle (recommended)

Store images **in the same folder as the post**. This keeps content self-contained and
means images move/delete with the post automatically.

```
content/posts/
└── 2026-06-10-my-new-post/
    ├── index.md          ← the post
    ├── hero.png          ← feature/hero image
    └── screenshot.png    ← inline image
```

Reference them in the markdown with just the filename — no path needed:

```markdown
![Alt text](screenshot.png)
```

Or as the hero image in front matter:

```yaml
featureimage: hero.png
```

### Shared / reusable images

If an image is used across **multiple posts** (a logo, a shared diagram), place it in
`static/images/` instead:

```
static/images/my-shared-diagram.png
```

Reference it with an absolute path:

```markdown
![Alt text](/images/my-shared-diagram.png)
```

### Legacy WordPress images

Older migrated posts reference images under `/wp-content/uploads/YYYY/MM/filename.png`.
Those files live in `static/wp-content/uploads/` and are committed to the repo.
**Do not add new images there** — use the page bundle approach above.

## Deploying

Push to `main`. GitHub Actions (`.github/workflows/deploy.yml`) will:
1. Check out the repo (including the Blowfish theme submodule)
2. Build with `hugo --minify`
3. Deploy the output directly to GitHub Pages via the official Pages actions

> **GitHub Pages source** must be set to **"GitHub Actions"** in  
> Settings → Pages → Source.

The mijn.host FTP deploy step is present in the workflow but commented out.
Uncomment it and add the three GitHub Secrets (`MIJNHOST_SERVER`, `MIJNHOST_USER`,
`MIJNHOST_PASS`) when ready to deploy to that host instead.

## Repo structure

```
blog.j81.nl/
├── assets/
│   └── css/
│       ├── schemes/jblue.css    # JOBICO brand color scheme (primary, neutral, secondary)
│       └── custom.css           # Global overrides: hero, footer, TOC, tags, cards, etc.
├── content/
│   ├── posts/                   # Blog posts (79 migrated from WordPress)
│   ├── howto/                   # HowTo guides (8 migrated from WordPress)
│   ├── about/_index.md          # About page → /about/
│   ├── contact/_index.md        # Contact page → /contact/
│   ├── pages/                   # Other WordPress pages (welcome, donate, etc.)
│   └── search/_index.md         # Search page
├── layouts/
│   ├── howto/list.html          # Custom HowTo section — titles grouped by `group` param
│   ├── _default/terms.html      # Taxonomy terms page — compact 3-column chip grid
│   └── partials/term-link/
│       └── card.html            # Compact category/tag chip (overrides Blowfish default)
├── static/
│   ├── images/                  # Shared/reusable images for new content
│   └── wp-content/uploads/      # Legacy WordPress media (526 files, 24.6 MB — committed)
├── themes/blowfish/             # Blowfish theme (git submodule)
├── working_data/                # WordPress export + full backup (gitignored, local only)
├── .github/workflows/
│   └── deploy.yml               # Build & deploy to GitHub Pages
└── hugo.yaml                    # Site configuration
```

## WordPress import (reference only)

The content in `content/posts/`, `content/howto/`, `content/about/`, and `content/contact/`
was generated from the WordPress XML export. You normally do not need to run this again.

Images from WordPress live in `static/wp-content/uploads/` and are committed to the repo.
All inline image references in content files have been updated to point to original
(non-resized) filenames — resized copies (`-300x180`, `@2x`, etc.) have been deleted.

## Giscus comments

Comments use [Giscus](https://giscus.app) (GitHub Discussions), configured in
`hugo.yaml`:

```yaml
params:
  article:
    showComments: true          # global on/off switch
  comments:
    giscus:
      repo: "j81blog/blog.j81.nl"
      repoID: "R_kgDOSh6CyA"
      category: "Announcements"
      categoryID: "DIC_kwDOSh6CyM4DAi3I"
```

Prerequisites (already done for this repo): the repo is public, the
[giscus GitHub App](https://github.com/apps/giscus) is installed, and
Discussions is enabled with an **Announcements**-type category. To regenerate
the IDs, visit [giscus.app](https://giscus.app), select the repo and category,
and copy `data-repo-id` / `data-category-id` from the generated snippet.

**Where comments appear:** automatically at the bottom of every `posts` and
`howto` entry (mapped per URL via `data-mapping="pathname"`, so each post gets
its own discussion thread). Regular pages never show comments.

### Turning comments on/off

There are two switches:

| Level | Setting | Value | Effect |
| --- | --- | --- | --- |
| **Whole site** | `params.article.showComments` in `hugo.yaml` | `true` | Comments enabled site-wide (default) |
| | | `false` | Comments hidden on all posts |
| **Single post** | `comments` in the post's front matter | *(omitted)* | Inherits the site default — comments show |
| | | `false` | Comments hidden on this post only |

Per-post is opt-out: comments are on unless a post sets `comments: false`.
Setting `comments: true` on a post is allowed but has no extra effect (it is
already the default). To disable comments for one post:

```yaml
---
title: My post
comments: false
---
```

**Cookie consent:** Giscus loads GitHub cookies, so it only initializes after
the visitor accepts the *functional* cookie category in the consent bar
(see `layouts/partials/cookieconsent.html`).
