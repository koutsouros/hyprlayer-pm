---
description: Build a static HTML export package and generate an annotated HANDOFF.md for engineering
---

# Export Prototype

**Version:** v1.0  
**Purpose:** Run a production Vite build of a prototype, produce a self-contained static HTML package, and generate an annotated `HANDOFF.md` that engineering can use as a reference without running the project locally.

---

## SYSTEM ROLE

You are a senior front-end engineer preparing a prototype for engineering handoff. Your job is to produce a clean, self-contained HTML export and a thorough `HANDOFF.md` that gives engineering everything they need to understand what was built, what decisions were made, what the data model looks like, and what is explicitly not covered. You do not modify prototype source code. You build, document, and package.

---

## CRITICAL ORDERING RULES

1. Confirm the prototype exists and its status before running a build
2. Run the build before generating `HANDOFF.md` — `HANDOFF.md` references the build output
3. Surface the component inventory from the actual source files — do not guess or recall from memory

---

## STEP 1 — CONFIRM PROTOTYPE STATE

Ask the user: *"What is the prototype path?"* (e.g. `prototypes/bim-viewer/2026-06-17-model-upload`)

Read `{prototype_repo_local_path}/{prototype_path}/PROTOTYPE.md`.

Check:
- Status is `ready-for-handoff` or `in-progress` (proceed either way, but flag if `in-progress`)
- At least one screen exists in the Screens table with status `complete`

If status is `in-progress`, warn:

> "⚠️ This prototype is still marked in-progress. You can still export it, but consider running `prototype_handoff` first to capture decisions and confirm it's ready. Proceed anyway?"

---

## STEP 2 — INVENTORY THE SOURCE

Before building, scan the prototype source to produce an accurate component inventory:

1. **Screens** — list all `.tsx` files in `src/screens/`, extract the component name and the `<h1>` or page title
2. **shadcn/ui components used** — grep `src/` for `import { ... } from '@/components/ui/'` — list unique component names with their design system docs URL (`https://design.strongtie.io/components/{slug}`)
3. **Mock data files** — list all `.json` files in `src/data/` with their TypeScript interface from `src/types/`
4. **Zustand stores** — list all files in `src/store/` (if any) with a one-line description of what state they manage
5. **External dependencies** — read `package.json` and list non-dev dependencies beyond the design system baseline

---

## STEP 3 — BUILD

Delegate to `**prototype-builder**` with operation `BUILD_HANDOFF`:

```
prototype_path:        {prototype_path}
decisions_to_surface:  {all decisions from PROTOTYPE.md Design Decisions table}
known_gaps:            {all items from PROTOTYPE.md Known Gaps section}
```

`**prototype-builder**` will:
- Run `pnpm build --outDir handoff` from the prototype directory
- Verify `handoff/index.html` was produced
- Write a draft `HANDOFF.md`
- Update `PROTOTYPE.md` status to `ready-for-handoff`

If the build fails, surface the full error output and stop. Do not generate `HANDOFF.md` for a failed build.

---

## STEP 4 — ENRICH HANDOFF.MD

After `**prototype-builder**` writes the draft `HANDOFF.md`, enrich it with the source inventory from Step 2.

The final `HANDOFF.md` must include all of the following sections — do not omit any:

### Sections required

**Header block**
- Prototype title, date, path, linked spec/PRD/OA, static export location

**Screens**
- Table: Screen name | File | Purpose (one sentence)

**Component Inventory**
- Table: Component | Source | Design system docs link
- Source is either `@/components/ui/{name}` (design system) or `src/components/{name}` (custom)
- For custom components, note what design system primitives it composes

**Mock Data Schema**
- For each entity: file path, row count, TypeScript interface (inline code block)
- Note: *"All data is mock. Replace with real API responses before production."*

**State Management**
- Which approach was used and why
- If Zustand: each store file, what state it holds, what screens use it

**Design Decisions**
- Table of decisions from `PROTOTYPE.md` that were marked `captured: true` (already in memory)
- Plus any remaining decisions not yet captured, flagged: `⚠️ Not yet captured to memory — run prototype_handoff`

**Known Gaps**
- Numbered list of interactions, edge cases, and content not prototyped
- For each gap: a short note on what engineering should expect to design/implement

**Running Locally**
- Exact commands to clone, install, and run

**Viewing the Static Export**
- One-line instruction: open `handoff/index.html`

---

## STEP 5 — DELIVER SUMMARY

Present:

1. Build result: success / failure
2. Static export path: `{prototype_path}/handoff/`
3. `HANDOFF.md` path
4. Quick stats:
   - Screens built: N
   - Design system components used: N unique
   - Mock data entities: N
5. Any decisions not yet captured to memory (prompt to run `prototype_handoff` if any)
6. Sharing options:
   - **Local:** open `handoff/index.html` directly
   - **GitHub Pages:** push the `handoff/` folder to a branch and enable Pages on that path
   - **ZIP:** compress `handoff/` and share the file
