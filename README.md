# EMU430 Quarto project (ready to push)

This folder is a **complete starter** for the EMU430 team website: **Home**, **Data**, and **Analysis** in Quarto, **R** import/cleaning, **`feeding_clean.RData`**, and a **GitHub Actions** workflow that builds and publishes to **GitHub Pages**.

**Course cross-check:** see [`COURSE_COMPLIANCE.md`](COURSE_COMPLIANCE.md) for a line-by-line checklist against the **initialization** and **final deliverable** PDFs (including a **5 min vs 10 min** presentation note).

## Team: Paw Patrol

**Display name:** Paw Patrol (used on the Home page and site title).

**Course list:** the final deliverable PDF listed **fixed GitHub team names** (e.g. `team_petra`, `rhapsody`, …). If your instructor assigned you to one of those names, use that name for the **GitHub Classroom team / repo**, and keep **“Paw Patrol”** as your **project title** on the site. If the instructor approved **Paw Patrol** as the official team name, you are fine using it everywhere.

## GitHub organization **pawpxtrol** / repo **`emu430`**

Your screenshot shows org **`pawpxtrol`** with **no repositories yet**. This project is wired to:

- **Repo:** `https://github.com/pawpxtrol/emu430`
- **Pages (after Actions):** `https://pawpxtrol.github.io/emu430/`

(`_quarto.yml` already matches.) Your **local folder** can stay `.../mateo_project/emu430` on disk.

**Create the repo (you must run this once on your Mac — GitHub needs *your* login):**

1. **Option A — website:** on `github.com/pawpxtrol`, green **New repository** → name **`emu430`** → Public → **no** README → Create.
2. **Option B — terminal (recommended):**

   ```bash
   gh auth login
   cd /Users/talyat/Documents/mateo_project/emu430
   chmod +x scripts/create-repo-pawpxtrol.sh
   bash scripts/create-repo-pawpxtrol.sh
   ./scripts/git-push-terminal.sh
   ```

The script creates **`pawpxtrol/emu430`** if missing, sets `origin` to **`git@github.com:pawpxtrol/emu430.git`**, then you push.

**SSH:** the key must belong to a **GitHub user who is a member of `pawpxtrol`** with permission to push (org Owner is fine). `ssh -T git@github.com` shows your **username**, not the org name — that is normal.

Teammates add **Assignment 1** profile links in `index.qmd`.

## New personal GitHub account (optional)

Only if someone on the team still needs an account: [github.com/signup](https://github.com/signup), then the org owner invites them to **`pawpxtrol`**.

## What you must provide (fill-in checklist)

| Item | Where to put it |
|------|------------------|
| **Official data URL** + access date + attribution | `data.qmd` (“Source and citation”) |
| **Team / repo URLs** | **`pawpxtrol/emu430`** in `_quarto.yml` (site: `pawpxtrol.github.io/emu430`) |
| **All member names** + **GitHub profile URLs** (Assignment 1) | `index.qmd` team table |
| **Course personal page** | Link from your EMU430 menu page **to** this published site |
| **AI use** (if any) | Mark sections + footnote with prompt (course rule) on any page you used AI for wording |
| **HADI PDF** | After site is correct: duplicate YAML per course PDF, render each page to PDF (or Word then merge), upload to HADI |

If anything in the raw file changes, replace `data/raw/hayvan_besleme_2024_07.xlsx` and re-run `Rscript R/prepare_data.R`.

## Push fails with `401` / Cursor `GIT_ASKPASS`

Use **Terminal.app**, not Cursor’s Git UI, and run **`./scripts/git-push-terminal.sh`** (it unsets `GIT_ASKPASS`).

Remote should be:

```bash
cd /Users/talyat/Documents/mateo_project/emu430
git remote set-url origin git@github.com:pawpxtrol/emu430.git
```

### SSH: `Permission denied (publickey)`

Generate a key and add the **`.pub`** file to the GitHub account that has access to org **`pawpxtrol`**:

```bash
cd /Users/talyat/Documents/mateo_project/emu430
bash scripts/setup-github-ssh.sh
```

Paste the printed line at **GitHub → Settings → SSH keys** (while logged in as the user who is in **`pawpxtrol`**). Then:

```bash
ssh -T git@github.com
./scripts/git-push-terminal.sh
```

### `Permission ... denied to <username>` (no access to org repo)

That user must be **invited to the `pawpxtrol` organization** (or given write access on **`emu430`**). Keys are per **user**, not per org.

### `couldn't find remote ref main`

Empty new repo has no `main` yet — a normal **`git push -u origin main`** after creation is enough. If the remote only has **`master`**, run `git ls-remote --heads origin` and use `git push -u origin main:master` if needed.

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

Workflow: `.github/workflows/publish-quarto.yml` — renders with **Quarto + R**, uploads **`_site`**, deploys with **GitHub Pages (Actions)**.

### One-time setup (if the workflow is orange or red)

1. **Settings → Pages → Build and deployment → Source**  
   Choose **GitHub Actions** (not “Deploy from a branch”). **Save.**  
   If this stays on a branch, the **Deploy** job will fail.

2. **First deploy only:** open the **in-progress / waiting** workflow run. If GitHub shows **“Waiting for approval”** for environment **`github-pages`**, click **Review deployments** → **Approve**.  
   (Orange / yellow often means **waiting for this approval**.)

3. **Re-run:** **Actions → Publish Quarto site →** pick the latest run → **Re-run all jobs** (after Pages source is GitHub Actions).

4. When green, **Settings → Pages** shows the live URL (e.g. **`https://pawpxtrol.github.io/emu430/`**).

If it still fails, open the **red** job → expand **Render site** or **Deploy to GitHub Pages** → copy the **last 30 lines** of the log into a message here.

## HADI submission (PDF)

The instructor asked for **HTML + PDF**. This repo is configured for **HTML** by default. For PDF export, add the YAML block from the **final deliverable** PDF (including `sidebar: false` and `format: pdf:` margins) to **each** page’s YAML when you render for submission — **render each page separately**, then **merge** PDFs (or use Word then one compiled file), and upload to [HADI](https://hadi.hacettepe.edu.tr).

**Initialization PDF** also required a **single-page** Phase-1 PDF on HADI by **April 7, 2026** (if that applied to your team, it is separate from this final site).

## Data file

- **Raw (tracked):** `data/raw/hayvan_besleme_2024_07.xlsx` (July 2024 Ankara-area street feeding table).
- **Clean (generated):** `data/feeding_clean.RData` — object name **`feeding`**.

## Ethics

Follow the course PDF: cite any borrowed code/ideas with links; verify all numbers; disclose AI-assisted text with prompts.
