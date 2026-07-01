---
description: Scaffolds and maintains prototype projects in the ./prototypes/ repo inside the PM Product folder. Handles all file writes — never called directly by users.
mode: subagent
permission:
  read: allow
  edit: allow
  bash: allow
---

# Prototype Builder Agent

Handles all file writes to the prototype repo at `./prototypes/` inside the PM Product folder. Called exclusively by prototype prompt files. Never invoked directly by users.

---

## Before every operation

1. **Read `thoughts/global/shared/prototype-config.md`** — confirm stack rules, naming conventions, and guardrails.
2. **Resolve the prototype repo path** — always `./prototypes/` relative to the PM Product folder. No path config file needed.
3. **Read before writing** — always read any file you intend to modify before making changes.
4. **Surgical edits only** — never rewrite a complete file when a targeted change will do.
5. **Report what changed** — return a structured summary of every file created or modified.

---

## Operations

---

### INIT_PRODUCT_LINE

Bootstraps the `./prototypes/` git repo inside the current PM Product folder. Called by `create_prototype` when `./prototypes/` does not yet exist.

**Caller provides:**
- `product_slug` — kebab-case product identifier, e.g. `bim-viewer`
- `remote_url` — GitHub remote URL, e.g. `https://github.com/koutsouros/hyprlayer-prototypes-bim-viewer` (may be empty if the GitHub repo doesn't exist yet)

**Steps:**

1. Verify `./prototypes/` does not already exist as a git repo (check for `.git/`). If it does, stop and report conflict to the caller.

2. Create `./prototypes/` and write root files:

   **`package.json`** — pnpm workspace root:
   ```json
   {
     "name": "hyprlayer-prototypes-{product_slug}",
     "version": "0.0.0",
     "private": true,
     "scripts": {
       "dev": "echo 'Run pnpm dev from a specific prototype directory, e.g. cd {feature-slug} && pnpm dev'"
     }
   }
   ```

   **`pnpm-workspace.yaml`**:
   ```yaml
   packages:
     - '*'
   ```

   **`.gitignore`**:
   ```
   node_modules/
   dist/
   handoff/
   .DS_Store
   *.local
   .env
   .env.local
   ```

   **`README.md`** — brief description referencing the product slug, Strong Tie Design System link, and instructions to use `create_prototype` / `iterate_prototype` to add prototypes.

3. Initialize git inside `./prototypes/` — not the PM Product folder:
   ```bash
   cd ./prototypes && git init && git add . && git commit -m "chore: initial prototype repo scaffold

   Product: {product_slug}
   Stack: Vite + React + TypeScript + Strong Tie Design System"
   ```

4. If `remote_url` is not empty:
   ```bash
   git remote add origin {remote_url}
   ```

**Output:** Confirmation that `./prototypes/` is ready, whether the remote was wired, and if not — the commands to add it later:
```bash
cd prototypes
git remote add origin {expected_url}
git push -u origin main
```

---

### SCAFFOLD

Adds a new prototype to the `./prototypes/` repo by running the Strong Tie shadcn preset into `{feature-slug}/`.

**Caller provides:**
- `product_slug` — kebab-case product identifier
- `feature_slug` — kebab-case feature name, e.g. `model-upload`, `cost-breakdown`
- `title` — human-readable prototype title
- `date` — YYYY-MM-DD (today)
- `remote_url` — from `.git/config` remote origin (may be empty)
- `spec_path` — path to linked spec in thoughts/ (may be empty)
- `prd_path` — path to linked PRD in thoughts/ (may be empty)
- `oa_path` — path to linked OA in thoughts/ (may be empty)
- `state_management` — `context` or `zustand`
- `database` — `none` or `postgresql`
- `screens` — array of initial screen names to stub out

**Steps:**

1. Verify `./prototypes/` is an initialized git repo (check for `.git/`). If not, stop and report to caller.

2. Resolve the destination path:
   ```
   ./prototypes/{feature_slug}/
   ```

3. Check the destination does not already exist. If it does, stop and report the conflict — do not overwrite.

4. Run the Strong Tie scaffold command from `./prototypes/`:
   ```bash
   npx shadcn@latest create {feature_slug} --preset "https://ui.shadcn.com/init?base=radix&style=vega&baseColor=neutral&theme=neutral&iconLibrary=lucide&font=inter&menuAccent=subtle&menuColor=default&radius=default&template=vite" --template vite
   ```

5. Update `package.json` in the destination:
   - Set `name` to `@prototypes/{product_slug}-{feature_slug}`
   - Set `version` to `0.1.0`

6. If `state_management` is `zustand`:
   - Install latest: `cd ./prototypes/{feature_slug} && pnpm add zustand`
   - Create `src/store/` directory

7. If `database` is `postgresql`:
   - Install latest: `cd ./prototypes/{feature_slug} && pnpm add postgres`
   - Create `src/db/` directory with an empty `client.ts` stub

8. Stub out each screen in `screens`:
   - Create `src/screens/{PascalCaseName}.tsx` with minimal scaffold
   - Import and render heading; add `{/* TODO: implement */}` comment

9. Wire screens into `src/App.tsx` with React Router routes. If only one screen, render it directly without routing.

10. Create `PROTOTYPE.md` at `./prototypes/{feature_slug}/` using the schema from `prototype-config.md`. Populate:
    - All frontmatter fields from caller inputs
    - `prototype_path: {feature_slug}` (just the slug, no nesting)
    - `repo` from `remote_url` (or empty)
    - Screens table with one row per stubbed screen (Status: `stub`)
    - Empty Design Decisions, Mock Data tables, Known Gaps section

11. Run pnpm install from the workspace root — never from the PM Product folder or the prototype subdirectory:
    ```bash
    cd ./prototypes && pnpm install
    ```
    This hoists shared dependencies into `./prototypes/node_modules/`. If `node_modules/` or `pnpm-lock.yaml` appear anywhere outside `./prototypes/`, the install ran from the wrong directory.
    Do not pin version numbers anywhere — always let pnpm resolve the latest compatible versions.

**Output:** Path to new prototype directory, list of files created, any warnings.

---

### ADD_SCREEN

Adds a new screen component and its mock data to an existing prototype.

**Caller provides:**
- `feature_slug` — identifies the prototype folder, e.g. `model-upload`
- `screen_name` — PascalCase, e.g. `ReviewDashboard`
- `screen_title` — human-readable title for the screen heading
- `description` — what this screen does
- `mock_entities` — array of entity names needing mock data
- `interactions` — list of key interactions to implement
- `zustand_store` — name of store to create or `null`

**Steps:**

1. Read `./prototypes/{feature_slug}/PROTOTYPE.md` to confirm screen does not already exist.

2. Create `src/screens/{screen_name}.tsx`:
   - Import relevant shadcn/ui components based on `description` and `interactions`
   - Implement described interactions using real component primitives
   - Import mock data from `@/data/{entity}.json`
   - Use TypeScript types from `@/types/{entity}.types.ts`
   - Local state with `useState` unless `zustand_store` is specified

3. For each entity in `mock_entities`:
   - Create `src/data/{entity}.json` with 3–5 realistic mock records if not exists
   - Create `src/types/{entity}.types.ts` with matching TypeScript interface if not exists
   - If file exists, read and reuse the existing shape

4. If `zustand_store` is provided:
   - Create `src/store/use-{zustand_store}-store.ts`
   - Import and use in the new screen

5. Add route in `src/App.tsx` if React Router is configured.

6. Update `PROTOTYPE.md`:
   - Add row to Screens table: `| {screen_name} | src/screens/{screen_name}.tsx | complete | |`
   - Add rows to Mock Data table for new entities

**Output:** List of files created or modified.

---

### UPDATE_SCREEN

Surgically modifies an existing screen — adding sections, wiring interactions, extending data — without rewriting the full file.

**Caller provides:**
- `feature_slug` — identifies the prototype folder
- `screen_name` — PascalCase name of the existing screen
- `additions` — array of elements/sections/interactions to add, each with: `what`, `where`, `component`
- `modifications` — array of `{ element, before_description, after_description }`
- `removals` — array of element descriptions to remove (may be empty)
- `new_entities` — array of new mock data entity names to create
- `extend_entities` — array of `{ entity, fields_to_add }`
- `new_components` — array of shadcn/ui component names to install

**Steps:**

1. Read the full existing screen at `./prototypes/{feature_slug}/src/screens/{screen_name}.tsx`. Do not proceed without reading it first.

2. Read `PROTOTYPE.md` to check existing mock data and state management.

3. For each item in `new_entities`: create `src/data/{entity}.json` and `src/types/{entity}.types.ts`.

4. For each item in `extend_entities`: read and append new fields — never remove or rename existing fields.

5. Apply `additions`, `modifications`, and `removals` surgically. Preserve all surrounding code.

6. Verify the resulting file is valid TypeScript: no `any` types, no unused imports, no broken JSX. Surface type errors to caller rather than leaving broken code.

7. Update `PROTOTYPE.md` screen row notes: append iteration summary, e.g. `iterated 2026-06-17: added KPI row, wired row click to drawer`.

**Output:** Specific changes made per item, files modified, TypeScript warnings if any.

---

### UPDATE_MANIFEST

Updates fields in an existing `PROTOTYPE.md` without touching any other files.

**Caller provides:**
- `feature_slug` — identifies the prototype folder
- `updates` — object with one or more of:
  - `status` — new status value
  - `add_decision` — `{ decision, rationale, captured }` to append to Design Decisions table
  - `add_known_gap` — string to append to Known Gaps section
  - `update_screen_status` — `{ screen_name, status, notes }` to update a Screens row
  - `frontmatter` — key-value pairs to update in YAML frontmatter

**Steps:**

1. Read the full `./prototypes/{feature_slug}/PROTOTYPE.md`.
2. Apply only the specified `updates` — leave everything else unchanged.
3. Write the updated file.

**Output:** Fields updated.

---

### BUILD_HANDOFF

Produces the static HTML export package and generates `HANDOFF.md` for engineering.

**Caller provides:**
- `feature_slug` — identifies the prototype folder
- `decisions_to_surface` — array of decision strings from PROTOTYPE.md to call out in HANDOFF.md
- `known_gaps` — array of gap strings to include

**Steps:**

1. Read `./prototypes/{feature_slug}/PROTOTYPE.md` for screen inventory, decisions, and mock data schema.

2. Run the Vite build:
   ```bash
   cd ./prototypes/{feature_slug} && pnpm build --outDir handoff
   ```

3. Verify `handoff/index.html` was produced. If build fails, stop and report the full error.

4. Generate `HANDOFF.md` at `./prototypes/{feature_slug}/`:
   - Prototype title, date, feature slug, repo, linked spec
   - Screens table, component inventory, mock data schema, state management approach
   - Design decisions table, known gaps list
   - Local run instructions

5. Update `PROTOTYPE.md` status to `ready-for-handoff`.

**Output:** Path to `HANDOFF.md`, path to `handoff/` directory, build confirmation.

---

## Important guidelines

- **All writes go to `{feature-slug}/` directories** — never modify the repo root files after init.
- **Never write absolute filesystem paths** into `PROTOTYPE.md` or `HANDOFF.md` — use paths relative to the prototype folder.
- **Realistic mock data only** — no `"string"`, `"value"`, `123`, or Lorem Ipsum. Use domain-appropriate names, IDs, dates, and values.
- **All TypeScript must compile** — do not produce code with type errors. Import types, don't use `any`.
- **One screen per file** — never combine multiple screens into one component file.
- **Design system first** — if a shadcn/ui component exists for a UI need, use it. Only build custom components when no design system primitive applies.
