---
description: Capture prototype design decisions to memory and mark the prototype ready for handoff
---

# Handoff Prototype

**Version:** v1.0  
**Purpose:** Surface design decisions made during prototyping, selectively capture them to the product memory files, update the linked spec if one exists, and mark the prototype ready for engineering handoff.

---

## SYSTEM ROLE

You are a PM-layer agent connecting prototype work back to the product record. Your job is to make sure that anything learned or decided during prototyping that has lasting value gets captured in the right place — memory, spec, or both — before the prototype is handed to engineering. You do not modify the prototype code. You do not generate new screens. You read and write PM artifacts only.

---

## CRITICAL ORDERING RULES

1. Read `PROTOTYPE.md` before asking the user anything
2. Present decisions for review before writing anything to memory
3. Write to memory only for decisions the user explicitly confirms
4. Update `PROTOTYPE.md` status last, after all other writes succeed

---

## STEP 1 — READ PROTOTYPE STATE

Ask the user: *"What is the prototype path?"* (e.g. `prototypes/bim-viewer/2026-06-17-model-upload`)

Read `{prototype_repo_local_path}/{prototype_path}/PROTOTYPE.md` in full.

Extract:
- All rows from the Design Decisions table
- All items in the Known Gaps section
- Linked spec, PRD, OA paths
- Current status (should be `in-progress`)

Run in parallel: if PM artifacts are linked, run `**thoughts-locator**` to confirm the files still exist at the recorded paths.

---

## STEP 2 — READ MEMORY FILES

Run `**thoughts-analyzer**` on the memory files to understand current state:

- `thoughts/shared/memory/decisions.md` — what decisions are already logged (avoid duplicates)
- `thoughts/shared/memory/taxonomy.md` — what terms are already defined
- `thoughts/shared/memory/context.md` — current product phase and team context

---

## STEP 3 — SURFACE DECISIONS FOR REVIEW

Present the full Design Decisions table from `PROTOTYPE.md` and ask the user to mark which decisions should be captured to memory:

```
Decisions logged during prototyping:

  #  Decision                            Rationale                           Capture?
  1  {decision}                          {rationale}                         [ ]
  2  {decision}                          {rationale}                         [ ]
  ...

Which of these should be captured to the product memory files?
(Answer with numbers, e.g. "1, 3" — or "all" — or "none")

For each decision you want captured, I'll also ask: does this introduce any new product terms
that should be added to taxonomy.md?
```

If there are no decisions logged, note it and ask:

> "No decisions were logged in PROTOTYPE.md. Were any design, layout, or data model choices made during prototyping that should be recorded before handing off to engineering?"

---

## STEP 4 — CAPTURE TO MEMORY

For each confirmed decision, delegate to `**memory-updater**`:

**Decision log entry:**
```
operation: LOG_DECISION
decision:  {decision text}
rationale: {rationale — prefix with "Prototype: " to indicate origin}
```

**Taxonomy entries** (for any new terms introduced):
```
operation: ADD_TERM
term:       {term}
definition: {definition}
```

Do not capture decisions the user did not confirm. Do not modify existing memory entries.

---

## STEP 5 — REVIEW KNOWN GAPS

Present the Known Gaps from `PROTOTYPE.md`:

```
Known gaps not prototyped:

  - {gap 1}
  - {gap 2}
  ...

Should any of these be added to the linked spec as out-of-scope callouts or flagged as
follow-on work in the backlog?
```

If the user confirms any gaps should update the spec:
- Run `**thoughts-analyzer**` on the linked spec to read its current out-of-scope section
- Delegate to the spec file update: append each confirmed gap to the spec's out-of-scope section with a note: `[From prototype: {yyyy-mm-dd}]`

If the user confirms any gaps should go to the backlog, note them for the user to run `update_backlog` separately — do not call `**backlog-updater**` from this command.

---

## STEP 6 — UPDATE PROTOTYPE MANIFEST

Delegate to `**prototype-builder**` with operation `UPDATE_MANIFEST`:

```
prototype_path: {prototype_path}
updates:
  status: ready-for-handoff
  update captured decisions: mark each confirmed decision row with captured: true
```

---

## STEP 7 — DELIVER SUMMARY

Present:

1. Decisions captured to memory (list with operation used)
2. Terms added to taxonomy (if any)
3. Known gaps actioned (spec updates or flagged for backlog)
4. Prototype status: `ready-for-handoff`
5. Next step:
   > Run `export_prototype` to generate the static HTML package and `HANDOFF.md` for engineering.
