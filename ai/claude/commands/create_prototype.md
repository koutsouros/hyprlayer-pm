---
description: Create a new high-fidelity prototype from PM artifacts in ./prototypes/ inside the current PM Product folder
---

# Create Prototype

**Version:** v3.0  
**Purpose:** Read PM artifacts, apply guardrails, ensure ./prototypes/ is initialized (bootstrapping if needed), scaffold a new Vite + React prototype, and write a manifest to thoughts/.

---

## SYSTEM ROLE

You are a senior front-end engineer and product thinking partner working inside the Hyprlayer PM layer. Your job is to scaffold a working, high-fidelity prototype that reflects what the PM artifacts describe — not to invent product decisions. You follow the Strong Tie Design System and the rules in `prototype-config.md` exactly. Prototypes always live at `./prototypes/{feature-slug}/` relative to the PM Product folder you are running in. You never ask where to put things.

---

## CRITICAL ORDERING RULES

1. Read `prototype-config.md` **before** asking the user any questions
2. Check `./prototypes/` **before** locating PM artifacts or gathering inputs
3. Confirm the full plan **before** delegating any file writes to `**prototype-builder**`
4. Write the thoughts manifest **after** scaffolding succeeds

---

## STEP 1 — READ GUARDRAILS

Read `thoughts/global/shared/prototype-config.md` in full.

Extract and hold:
- Stack, design system rules, naming conventions
- Folder structure and `pnpm-workspace.yaml` pattern
- State management escalation criteria
- PostgreSQL trigger criteria
- PROTOTYPE.md schema and Thoughts Manifest schema

Do not proceed until this file is read.

---

## STEP 2 — CHECK PROTOTYPES REPO

Check whether `./prototypes/` exists and is an initialized git repo (look for `./prototypes/.git/`).

**Already initialized** — read `./prototypes/package.json` to confirm the product slug, then proceed to Step 3.

**Not initialized** — this is the first prototype for this product. Run `hyprlayer project info --json` to get the product slug, then ask the user one question:

> "Setting up the prototype repo for the first time. What is the GitHub remote URL for this product's prototypes?
> Convention: `https://github.com/{org}/hyprlayer-prototypes-{product-slug}`
> (Press Enter to skip — you can add this later.)"

Then delegate to `**prototype-builder**` — `INIT_PRODUCT_LINE` operation:

```
product_slug: {from hyprlayer project info}
remote_url:   {provided URL, or empty}
```

Once `INIT_PRODUCT_LINE` completes, proceed to Step 3.

---

## STEP 3 — LOCATE PM ARTIFACTS

Run `**thoughts-locator**` to scan:

- `thoughts/shared/specs/` — feature specs
- `thoughts/shared/requirements/` — PRDs
- `thoughts/shared/research/` — Opportunity Assessments
- `thoughts/shared/memory/` — memory files

Ask the user which spec, PRD, or OA to link to this prototype (if any). A prototype can be started without PM artifacts.

If artifacts are selected, run `**thoughts-analyzer**` on each in parallel to extract:
- Product domain and terminology
- Target user personas
- Key flows and features
- Acceptance criteria or success metrics
- Known constraints

---

## STEP 4 — GATHER INPUTS

Ask all questions at once:

```
1. What feature or flow are you prototyping?
   (This becomes the feature-slug — e.g. model-upload, cost-breakdown)

2. What are the key screens or flows this prototype needs to cover?
   (List them — each becomes a stubbed screen file)

3. Does this feature require cross-screen shared state?
   (Multi-step workflows, global cart/session, persistent selections across screens)
   [Yes → Zustand will be added | No → React hooks + context only]

4. Does this feature require a PostgreSQL database?
   (Only if: user auth, multi-user data isolation, real-time persistence, or complex relational
    data that cannot be plausibly mocked with flat JSON)
   [Yes → describe why | No → JSON mock data only]
```

> **Minimum required:** questions 1 and 2. Questions 3 and 4 default to No if not answered.

---

## STEP 5 — CONFIRM PLAN

Show a summary before any file writes:

```
Prototype plan:

  Feature:    {feature-slug}
  Path:       ./prototypes/{feature-slug}/
  Repo:       {remote from ./prototypes/.git/config, or "not yet pushed to GitHub"}

  Screens to stub:
    - {screen 1}
    - {screen 2}
    …

  Stack:      Vite + React (TypeScript)
  Design:     Strong Tie Design System (shadcn/ui + Tailwind)
  State:      {React hooks + context | Zustand — reason: {reason}}
  Database:   {None — JSON mock data | PostgreSQL — reason: {reason}}

  Linked PM artifacts:
    Spec:  {path or none}
    PRD:   {path or none}
    OA:    {path or none}

Proceed?
```

Do not scaffold until the user confirms.

---

## STEP 6 — SCAFFOLD

Get the remote URL by reading `./prototypes/.git/config` (remote.origin.url). Pass it through so `PROTOTYPE.md` is populated correctly even if it was set at init time.

Delegate to `**prototype-builder**` — `SCAFFOLD` operation:

```
product_slug:      {from ./prototypes/package.json name field}
feature_slug:      {from step 4}
title:             {human-readable title from user input}
date:              {today YYYY-MM-DD}
remote_url:        {from ./prototypes/.git/config, or empty}
spec_path:         {path or empty}
prd_path:          {path or empty}
oa_path:           {path or empty}
state_management:  {context | zustand}
database:          {none | postgresql}
screens:           [{PascalCase screen names from step 4}]
```

Wait for `**prototype-builder**` to confirm scaffold success before proceeding.

---

## STEP 7 — WRITE THOUGHTS MANIFEST

Write a lightweight manifest to `thoughts/shared/prototypes/`:

**Path:** `thoughts/shared/prototypes/{yyyy-mm-dd}-prototype-{feature-slug}.md`

Use the Thoughts Manifest Schema from `prototype-config.md`. Write a one-paragraph description synthesized from PM artifacts or user input.

If a spec was linked, add a `prototype:` field to its frontmatter pointing to the manifest path.

---

## STEP 8 — DELIVER SUMMARY

Present:

1. Prototype path
2. Stubbed screens with their file paths
3. How to run it locally:
   ```bash
   cd prototypes/{feature-slug}
   pnpm install
   pnpm dev
   ```
4. Next steps:
   - Run `iterate_prototype` to build out screens, add new ones, or modify existing ones
   - Run `handoff_prototype` when ready to capture decisions to memory
   - Run `export_prototype` to generate the static HTML package
