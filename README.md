# EMU430 Quarto project (ready to push)

This folder is a **complete starter** for the EMU430 team website: **Home**, **Data**, and **Analysis** in Quarto, **R** import/cleaning, **`feeding_clean.RData`**, and a **GitHub Actions** workflow that builds and publishes to **GitHub Pages**.

**Course cross-check:** see [`COURSE_COMPLIANCE.md`](COURSE_COMPLIANCE.md) for a line-by-line checklist against the **initialization** and **final deliverable** PDFs (including a **5 min vs 10 min** presentation note).

## Team: Paw Patrol

**Display name:** Paw Patrol (used on the Home page and site title).

**Course list:** the final deliverable PDF listed **fixed GitHub team names** (e.g. `team_petra`, `rhapsody`, …). If your instructor assigned you to one of those names, use that name for the **GitHub Classroom team / repo**, and keep **“Paw Patrol”** as your **project title** on the site. If the instructor approved **Paw Patrol** as the official team name, you are fine using it everywhere.

## GitHub account **pawpatrol** / repo **`simply-scheme`**

`_quarto.yml` is set for **`https://github.com/pawpatrol/simply-scheme`** and Pages **`https://pawpatrol.github.io/simply-scheme/`**. Your **local folder** can still be named `emu430` on disk; only the **GitHub repo name** matters for the remote and URLs.

**Heads-up:** `simply-scheme` already exists with older content. The first push of this project may require merging histories or a **force push** (which **overwrites** the old default branch). Back up anything you still need from that repo before replacing it.

Teammates add their **Assignment 1** profile links in `index.qmd`; they do not need to own the repo.

## New personal GitHub account (optional)

1. Sign up at [github.com/signup](https://github.com/signup) if you still need an individual account.
2. **Username:** letters, numbers, hyphens — **no spaces**. Display name can stay **Paw Patrol** in [Profile settings](https://github.com/settings/profile).
3. Remote target is **`github.com/pawpatrol/simply-scheme`** (existing repo).
4. Push from Terminal (see below), then enable **Pages** from **`gh-pages`** after the first successful workflow run.

## What you must provide (fill-in checklist)

| Item | Where to put it |
|------|------------------|
| **Official data URL** + access date + attribution | `data.qmd` (“Source and citation”) |
| **Team / repo URLs** | **`pawpatrol/simply-scheme`** in `_quarto.yml` (live site: `pawpatrol.github.io/simply-scheme`) |
| **All member names** + **GitHub profile URLs** (Assignment 1) | `index.qmd` team table |
| **Course personal page** | Link from your EMU430 menu page **to** this published site |
| **AI use** (if any) | Mark sections + footnote with prompt (course rule) on any page you used AI for wording |
| **HADI PDF** | After site is correct: duplicate YAML per course PDF, render each page to PDF (or Word then merge), upload to HADI |

If anything in the raw file changes, replace `data/raw/hayvan_besleme_2024_07.xlsx` and re-run `Rscript R/prepare_data.R`.

## Push fails with `401` / `Missing or invalid credentials` (Cursor)

Cursor sets **`GIT_ASKPASS`** to an internal helper; it often breaks **`git push`** over HTTPS to GitHub.

**Do this:**

1. Remote must be **`pawpatrol/simply-scheme`**. Set it once:

   ```bash
   cd /Users/talyat/Documents/mateo_project/emu430
   git remote set-url origin git@github.com:pawpatrol/simply-scheme.git
   ```

   If the old repo has a different history, either merge (`git pull origin main --allow-unrelated-histories` then resolve) or **force** (destructive): `git push -u origin main --force` — only after backing up the old repo.

2. Open **Terminal.app** (Apple’s Terminal, not Cursor’s tab).
3. Run:

   ```bash
   cd /Users/talyat/Documents/mateo_project/emu430
   chmod +x scripts/git-push-terminal.sh
   ./scripts/git-push-terminal.sh
   ```

   The script **unsets** `GIT_ASKPASS` so macOS can use **Keychain** or prompt in the terminal.

4. If Git still asks for a password: GitHub no longer accepts account passwords over HTTPS. Use a **[Personal Access Token](https://github.com/settings/tokens)** as the password, or switch to SSH:

   ```bash
   git remote set-url origin git@github.com:pawpatrol/simply-scheme.git
   ssh -T git@github.com    # must say “Hi pawpatrol!”
   ./scripts/git-push-terminal.sh
   ```

5. Or use **GitHub CLI** once, then push from Terminal:

   ```bash
   gh auth login
   gh auth setup-git
   cd /Users/talyat/Documents/mateo_project/emu430
   ./scripts/git-push-terminal.sh
   ```

### SSH: `Permission denied (publickey)`

GitHub only accepts SSH if this Mac has an **SSH key** and you paste its **public** key into GitHub while logged in as **`pawpatrol`**: **Settings → SSH and GPG keys → New SSH key**.

**Quick setup** (Terminal.app):

```bash
cd /Users/talyat/Documents/mateo_project/emu430
bash scripts/setup-github-ssh.sh
```

Copy the **one line** it prints → GitHub → New SSH key → save. Then:

```bash
ssh -T git@github.com
./scripts/git-push-terminal.sh
```

You should see: `Hi pawpatrol! You've successfully authenticated...`

### `Permission ... denied to pawpxtroller` (wrong GitHub account)

If the error says **`denied to pawpxtroller`** but the repo is **`pawpatrol/simply-scheme`**, your Mac is using an SSH key that is registered on **`pawpxtroller`**, not **`pawpatrol`**. GitHub will reject the push.

**Pick one:**

1. **Use a dedicated SSH key for `pawpatrol`.** GitHub does **not** allow the same public key on two different users. If your current key is on **`pawpxtroller`**, create a **new** key pair, add **only** the new `.pub` file to **`pawpatrol`** → SSH keys, then use the SSH config in (2) so this repo uses that key.

2. **`~/.ssh/config` host alias** (recommended when you have two accounts):

   ```text
   Host github.com-pawpatrol
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_pawpatrol
     IdentitiesOnly yes

   Host github.com
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_github
     IdentitiesOnly yes
   ```

   - Create **`~/.ssh/id_ed25519_pawpatrol`** (new key), add **only** `id_ed25519_pawpatrol.pub` to **`pawpatrol`** → SSH keys.  
   - Point this repo at the host alias:

   ```bash
   cd /Users/talyat/Documents/mateo_project/emu430
   git remote set-url origin git@github.com-pawpatrol:pawpatrol/simply-scheme.git
   ssh -T git@github.com-pawpatrol   # should say Hi pawpatrol!
   ./scripts/git-push-terminal.sh
   ```

3. **Add `pawpxtroller` as a collaborator** on **`pawpatrol/simply-scheme`** (Write access). Then pushing as `pawpxtroller` works without moving the repo.

### `couldn't find remote ref main`

The GitHub repo may use **`master`** as default, or be empty. Check:

```bash
git ls-remote --heads origin
```

If you see **`refs/heads/master`** but no `main`, either push with `git push -u origin main:master` or rename: `git push -u origin main` after creating `main` on remote — or `git branch -M main` and force push if you intend to replace the default branch.

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
