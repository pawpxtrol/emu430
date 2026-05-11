# EMU430 Quarto project (ready to push)

This folder is a **complete starter** for the EMU430 team website: **Home**, **Data**, and **Analysis** in Quarto, **R** import/cleaning, **`feeding_clean.RData`**, and a **GitHub Actions** workflow that builds and publishes to **GitHub Pages**.

**Course cross-check:** see [`COURSE_COMPLIANCE.md`](COURSE_COMPLIANCE.md) for a line-by-line checklist against the **initialization** and **final deliverable** PDFs (including a **5 min vs 10 min** presentation note).

## Team: Paw Patrol

**Display name:** Paw Patrol (used on the Home page and site title).

**Course list:** the final deliverable PDF listed **fixed GitHub team names** (e.g. `team_petra`, `rhapsody`, …). If your instructor assigned you to one of those names, use that name for the **GitHub Classroom team / repo**, and keep **“Paw Patrol”** as your **project title** on the site. If the instructor approved **Paw Patrol** as the official team name, you are fine using it everywhere.

## GitHub org **pawpxtrol**

`_quarto.yml` is set for **`https://github.com/pawpxtrol/emu430`** and project Pages **`https://pawpxtrol.github.io/emu430/`**. If GitHub Classroom created a **different repository name**, edit **both** `site-url` and `repo-url` in `_quarto.yml` (keep org **`pawpxtrol`**).

Members still need **personal GitHub accounts** to be **invited to the org** or added as collaborators on the repo (Assignment 1 profile links go in `index.qmd`).

## New personal GitHub account (optional)

1. Sign up at [github.com/signup](https://github.com/signup) if you still need an individual account.
2. **Username:** letters, numbers, hyphens — **no spaces**. Display name can stay **Paw Patrol** in [Profile settings](https://github.com/settings/profile).
3. Ask the org owner to **invite** you to **`pawpxtrol`** (or to the team repo).
4. Push this project to **`github.com/pawpxtrol/emu430`** (or your real Classroom repo) and enable **Pages** from **`gh-pages`** after the first successful workflow run.

## What you must provide (fill-in checklist)

| Item | Where to put it |
|------|------------------|
| **Official data URL** + access date + attribution | `data.qmd` (“Source and citation”) |
| **Team / repo URLs** | Already set for org **`pawpxtrol`** / repo **`emu430`** in `_quarto.yml` — change only if your repo slug differs |
| **All member names** + **GitHub profile URLs** (Assignment 1) | `index.qmd` team table |
| **Course personal page** | Link from your EMU430 menu page **to** this published site |
| **AI use** (if any) | Mark sections + footnote with prompt (course rule) on any page you used AI for wording |
| **HADI PDF** | After site is correct: duplicate YAML per course PDF, render each page to PDF (or Word then merge), upload to HADI |

If anything in the raw file changes, replace `data/raw/hayvan_besleme_2024_07.xlsx` and re-run `Rscript R/prepare_data.R`.

## Copy into your team repository

**Option A — this folder becomes the repo root:** initialize git here (or clone your empty team repo and copy these files in).

**Option B — monorepo subfolder:** move everything under `emu430/` and set GitHub Actions `defaults.run.working-directory` to that subfolder (or run commands from there).

## Local setup (once per machine)

1. Install [R](https://cran.r-project.org/) and [Quarto](https://quarto.org/docs/get-started/).
2. From **this directory** (`emu430/`):

   ```bash
   Rscript R/prepare_data.R
   quarto render
   ```

3. Open `_site/index.html` in a browser to preview.

## GitHub Pages (automated)

Workflow: `.github/workflows/publish-quarto.yml`

1. Push this project to the **`main`** branch of your team repo.
2. In GitHub: **Settings → Pages → Build and deployment → Branch `gh-pages` / root** (the `quarto publish` action creates/updates `gh-pages`).
3. First push may require **Settings → Actions → General → Workflow permissions: Read and write**.

## HADI submission (PDF)

The instructor asked for **HTML + PDF**. This repo is configured for **HTML** by default. For PDF export, add the YAML block from the **final deliverable** PDF (including `sidebar: false` and `format: pdf:` margins) to **each** page’s YAML when you render for submission — **render each page separately**, then **merge** PDFs (or use Word then one compiled file), and upload to [HADI](https://hadi.hacettepe.edu.tr).

**Initialization PDF** also required a **single-page** Phase-1 PDF on HADI by **April 7, 2026** (if that applied to your team, it is separate from this final site).

## Data file

- **Raw (tracked):** `data/raw/hayvan_besleme_2024_07.xlsx` (July 2024 Ankara-area street feeding table).
- **Clean (generated):** `data/feeding_clean.RData` — object name **`feeding`**.

## Ethics

Follow the course PDF: cite any borrowed code/ideas with links; verify all numbers; disclose AI-assisted text with prompts.
