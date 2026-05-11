# EMU430 — compliance check (course PDFs vs this repo)

Sources checked:

- Final deliverable: `project_final_deliverable_49c8583d1970be8ff3970174b6f60dec.pdf` (due **May 12, 2026**)
- Initialization guide: `emu430_2025_2026_spring_project_guide_and_task1_6ee7edf5228e978.pdf`
- Dataset: `2024_TEMMUZ_AYI_SAĞLIK_DAİRESİ_HAYVAN_BESLEME_VERİLERİ.xlsx` (July 2024; **367 × 7** in the copy under `data/raw/`)

Legend: **Met** = covered by this repo or docs; **You** = your action outside the template; **Ask** = clarify with instructor.

---

## Final deliverable PDF

| Requirement | Status | Where / notes |
|-------------|--------|----------------|
| GitHub team invitation; first acceptor creates team from **listed names** | **You** | Names: `team_petra`, `rhapsody`, `nrg`, … `analytica`. Align **Classroom team/repo** with that list unless instructor approved otherwise (e.g. display name **Paw Patrol** only on site). |
| **Three pages:** home, data, analysis | **Met** | `index.qmd`, `data.qmd`, `analysis.qmd` + navbar in `_quarto.yml`. |
| **Home:** team name, members, project title, short description | **Met** / **You** | Paw Patrol + title on `index.qmd`; fill member names. |
| Member names **linked to Assignment 1 GitHub pages** | **You** | `index.qmd` table — replace `YOUR_USERNAME` and empty links. |
| **Personal coursework pages** link **to** project + short description under Project menu | **You** | Not in repo; each student edits their own site. |
| Ethics; borrow → **direct link**; AI → **highlight + footnote with prompt** | **Met** / **You** | `README.md`, footers on `data.qmd` / `analysis.qmd`; you mark any AI text. |
| **Quarto** + **GitHub Project Page** + **PDF** to **HADI** | **Met** / **You** | HTML via Quarto + Pages workflow; PDF: add course YAML per page, render, merge, upload (**README**). |
| **~10 minute** presentation; **no PowerPoint**; use **project website** | **You** | Rehearse from live Pages URL. |
| Text and code **together** in Quarto; code **collapsible**; outputs **visible** | **Met** | One `.qmd` **per page** (standard for Quarto websites = “same file” per page). `code-fold: true` in `_quarto.yml`; tables/plots shown. |
| **Data page:** what data is; **sources**; choice; **objectives**; **accomplishments** | **Met** / **You** | `data.qmd` — **add real source URL**; accomplishments section added. |
| **Data page:** import + prep; cleaning / NAs / etc. | **Met** | `data.qmd` + `R/prepare_data.R` (trim ilçe, parse kg, vehicle/personnel; **no row drops** for NA — stated in Data page). |
| **Data page:** **`.RData`** + **explicit download link** | **Met** | `feeding_clean.RData`, object `feeding`; link + `resources` in `_quarto.yml`. |
| **EDA:** overview, columns, distributions, directions for further work | **Met** | `analysis.qmd` (+ column table on Data page). |
| Strong narrative; avoid shallow / repetitive code | **You** | Extend prose before submit; tailor takeaways. |
| **Key takeaways** **3–5 bullets**: end of **Home**, start of **Analysis**; topic, data, important aspects, interesting results, main outcome | **Met** | Five bullets each on `index.qmd` and `analysis.qmd`. |
| Analysis page: styling, structure, not huge raw dumps | **Met** / **You** | Theme `cosmo`; keep outputs concise. |
| More **words** than bare code | **You** | Add interpretation before deadline. |
| **HTML + PDF** from Quarto; **each page** to PDF or Word; **merge** if multiple PDFs | **You** | Instructor YAML (`sidebar: false`, margins) — apply when rendering for HADI (**README**). |
| Optional **1–2 min** teaser video (+5) | **You** | Not automated here. |

---

## Initialization guide PDF (Phase 1)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Teams **4–6** students | **You** | Extend `index.qmd` table if you have 5–6 people. |
| **R** on real data; **Quarto**; **GitHub** | **Met** | |
| Data non-confidential; public at end; **Turkey-related** encouraged | **Met** | Ankara operational feeding data. |
| Deliverable 1: **single-page PDF** on HADI by **Apr 7, 2026** | **You** | Separate from this website; one member submits for team. |
| Prefer **RData** path raw → processed | **Met** | `prepare_data.R` → `feeding_clean.RData`. |
| Ethics / AI | **Met** | Same as final PDF. |

---

## Conflicts / clarifications between the two PDFs

| Topic | Guide PDF | Final PDF | What to do |
|-------|-----------|-----------|------------|
| **Presentation length** | “**5-minute**” presentation + max **8-page** conference paper (initialization doc, future phase wording) | “**10-minute**” presentation; conference paper not repeated | Treat **10 minutes** and **web project** as binding for **final** unless the instructor says otherwise. **Ask** if you must also submit the 8-page paper. |

---

## Dataset vs `R/prepare_data.R`

| Excel column | Handled |
|--------------|---------|
| `TARİH` | → `tarih` (date) |
| `İLÇE` | → `ilce` (trimmed) |
| `MAHALLE/SOKAK` | → `mahalle_sokak` (trimmed) |
| `BESLEME NOKTASI SAYISI` | → `besleme_noktasi_sayisi` |
| Kuru mama (text e.g. `84 KG`) | → `mama_kg` |
| Araç (e.g. `3`, `-`, `Y3`) | → `arac_sayisi` |
| Personel (`9`, `-`) | → `personel_sayisi` |

---

## GitHub Pages URL (org vs user)

- **User repo:** `https://<username>.github.io/<repo>/`
- **Organization repo:** `https://<org>.github.io/<repo>/`

Set `site-url` in `_quarto.yml` to the URL that actually opens your site after Pages is enabled.

---

## Files you should still edit before submission

1. `data.qmd` — **exact data source URL** + access date.  
2. `index.qmd` — **all** members + **working** GitHub profile links.  
3. `_quarto.yml` — **`site-url`** and **`repo-url`**.  
4. HADI — **PDF** bundle per instructor instructions.  
5. Each person’s **course Project menu** → link to this site.
