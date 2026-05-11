# EMU430 project — step-by-step (your dataset + course PDFs)

Paths you are using:

- Data: `/Users/talyat/Downloads/2024_TEMMUZ_AYI_SAĞLIK_DAİRESİ_HAYVAN_BESLEME_VERİLERİ.xlsx`  
  (same file if your filesystem shows `SAĞLIK` / `DAİRESİ` — macOS can use different Unicode for dotted İ.)
- Phase 1 / guide: `/Users/talyat/Downloads/emu430_2025_2026_spring_project_guide_and_task1_6ee7edf5228e978.pdf`
- Final deliverable: `/Users/talyat/Downloads/project_final_deliverable_49c8583d1970be8ff3970174b6f60dec.pdf`

Work in your **team GitHub repo** (the one from the course invitation), not only on your laptop. This folder (`mateo_project/emu430/`) is a local checklist you can copy or link from your repo’s `README` if you want.

---

## Phase A — Course admin (once per team)

1. **Accept the GitHub Classroom / team invitation** (final deliverable PDF, §1).  
2. **First member** creates the team with the **exact team name** from the list; others join that team.  
3. **Turn on GitHub Pages** for the repo (Settings → Pages): source is usually `main` + `/docs` or root, depending on how the template is set up — match what the instructor’s template says.  
4. Everyone adds a **link on their personal Assignment-1 GitHub page** back to the **project site** (final deliverable + guide).

---

## Phase B — Initialization (Guide PDF, “Project Deliverable 1”)

These items are what Task 1 asked for; keep the same story for the final site.

5. **Lock the roster**: 4–6 members (or as agreed with the instructor).  
6. **Confirm team name** = **GitHub Pages URL slug** (short, professional).  
7. **Write 1 short paragraph each**: dataset description, why it fits the project, **objectives**, what you hope to **find**, **preliminary plan** (data → cleaning → EDA → deeper questions → visuals).  
8. **Data references**: official source URL, retrieval date, license/usage if stated (health directorate / open data portal — cite whatever page you downloaded from).  
9. **Ethics / AI**: anything from generators → mark it, add prompt in a footnote; you remain responsible for correctness (both PDFs).

---

## Phase C — Tooling on each computer

10. Install **R** (current release) and **RStudio** or **Positron**.  
11. Install **Quarto** and confirm `quarto check` passes.  
12. In R, install packages you will likely need, e.g.:

    ```r
    install.packages(c("tidyverse", "readxl", "janitor", "skimr", "here"))
    ```

---

## Phase D — Reproducible data pipeline (feeds the Data page + `.RData`)

13. In the **team repo**, add `data/raw/` and **copy** the Excel file into it (keep the Downloads original as backup). Use a **simple ASCII filename** in the repo if you want fewer path issues, e.g. `data/raw/hayvan_besleme_2024_07.xlsx`.  
14. Create `R/01_import_clean.R` (or `.qmd` chunk) that:

    - Reads the sheet with `readxl::read_excel()`.  
    - Uses `janitor::clean_names()` for safe column names.  
    - Documents what each column means (Turkish headers → English snake_case + glossary table on the Data page).  
    - **Parses** fields that are text but represent numbers (e.g. `"5 KG"` → numeric kg) with `readr::parse_number()` or regex; document dropped/changed rows.  
    - Handles missing values explicitly (rule: row drop vs impute — justify in prose).  

15. Build a single analysis-ready object, e.g. `feeding <- ...` (tibble/data frame).  
16. Save for the website:

    ```r
    save(feeding, file = here::here("data", "feeding_clean.RData"))
    ```

17. **Commit** `data/raw/…xlsx` (if size and license allow) **or** document exact download steps if the file must stay external.  
18. On the **Data** Quarto page: link to `feeding_clean.RData` with a raw GitHub link (or release asset) so graders can download it (final deliverable checklist).

---

## Phase E — Quarto website structure (final deliverable PDF)

19. Keep **three** Quarto documents as a minimum: `index.qmd` (home), `data.qmd`, `analysis.qmd` (names may match the template).  
20. **`_quarto.yml`**: project type `website`, navbar entries for Home / Data / Analysis.  
21. **Home (`index.qmd`)**: team name, members + GitHub links, title, short description. At the **bottom**: **Key takeaways** (3–5 bullets) — required placement (final deliverable).  
22. **Data (`data.qmd`)**: source + ethics; import and **all** preprocessing steps in words; optional collapsible code; link to `.RData`.  
23. **Analysis (`analysis.qmd`)`: start with the **same Key takeaways** (3–5 bullets) at the **top**; then EDA narrative, plots, tables; code collapsible; avoid huge raw dumps in the rendered page.  
24. For **PDF export** per page, add the YAML block the instructor gave (title/sidebar/format/margins) when you render docx/pdf for submission — see final deliverable PDF §3 “Reporting”.

---

## Phase F — EDA quality bar (final deliverable PDF)

25. **Column dictionary**: human-readable meanings + units.  
26. **Distributions**: by district (`İLÇE`), dates, feeding points, food amount, vehicles, personnel — use plots that answer real questions (e.g. inequality across districts, weekly pattern if you have enough dates).  
27. **At least one “so what”**: policy or operations insight, not only charts.  
28. **No shallow copy-paste**: each section should advance the story; tie figures to text.

---

## Phase G — Build, publish, submit

29. `quarto render` the site; fix warnings that affect outputs.  
30. Push to `main`; verify **GitHub Pages** shows the HTML.  
31. Render **PDF** (or Word → merge) per course instructions; upload to **HADI** (`https://hadi.hacettepe.edu.tr`).  
32. **Presentation**: use the **website** in class; no separate PowerPoint (final deliverable). Rehearse ~10 minutes.  
33. Optional: **1–2 min teaser video** for +5 bonus.

---

## Suggested order this week

| Order | Task |
|------:|------|
| 1 | GitHub team + Pages working |
| 2 | Data file in repo + import script + `feeding_clean.RData` |
| 3 | Data page draft (sources + cleaning story + download link) |
| 4 | Analysis page: EDA + takeaways top/bottom |
| 5 | Polish home; render PDF; HADI upload |

---

## Quick reference — PDF → what to deliver

| Source | You deliver |
|--------|-------------|
| Guide PDF | Team, name, dataset rationale, plan, references (keep consistent on site) |
| Final PDF | Quarto site (home/data/analysis), `.RData`, EDA depth, takeaways placement, HTML + PDF to HADI, live presentation from site |

If you want this repo to **also** contain a ready-made Quarto skeleton and `R/01_import_clean.R` wired to `here::here()`, say so and we can add those files next.
