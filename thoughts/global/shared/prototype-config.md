# Prototype Configuration

This file is the single source of truth for all prototype work in Hyprlayer-PM. All prototype skills and the `@prototype-builder` agent read this file before doing any work. Do not override these settings inline — change them here.

---

## Stack

**Framework:** Vite + React (TypeScript)

Vite is the required default for all new React projects per the Strong Tie framework policy. Next.js requires explicit management approval and is not permitted for prototypes. See: https://design.strongtie.io/framework-recommendations

**Node requirement:** >= 20.0.0  
**Package manager:** pnpm (workspace-compatible)  
**Language:** TypeScript (strict mode)

---

## Design System

**System:** Strong Tie Design System  
**Reference:** https://design.strongtie.io/  
**Foundation:** shadcn/ui + Tailwind CSS + Radix UI primitives  
**Icon library:** Lucide  
**Font:** Inter  

### Scaffold command

Run this to initialize a new prototype with the Strong Tie preset:

```bash
npx shadcn@latest create --preset "https://ui.shadcn.com/init?base=radix&style=vega&baseColor=neutral&theme=neutral&iconLibrary=lucide&font=inter&menuAccent=subtle&menuColor=default&radius=default&template=vite" --template vite
```

### Component usage rules

- Always import components from `@/components/ui/` (shadcn copy-paste model)
- Add components via `npx shadcn@latest add {component}` — do not write them from scratch
- Use only components documented at https://design.strongtie.io/components
- Custom components go in `src/components/` and must compose from design system primitives
- Never override design system CSS variables inline — use Tailwind utility classes only

---

## Prototype Repository

Prototypes live inside the PM's Product folder as a dedicated git repo checked out at `./prototypes/`. This keeps the prototype repo alongside all PM work for the same product, with thoughts already accessible via the Product folder's existing symlink.

### Location

```
{PM Product Folder}/
├── thoughts/ → /path/to/master-thoughts/   ← symlink to master thoughts for this product
└── prototypes/                             ← git repo: hyprlayer-prototypes-{slug}
    ├── .git/
    ├── package.json                        ← pnpm workspace root
    ├── pnpm-workspace.yaml
    ├── pnpm-lock.yaml
    ├── node_modules/                       ← hoisted, shared across all prototypes
    ├── README.md
    ├── .gitignore
    └── {feature-slug}/                     ← individual prototypes
```

Skills and agents (`ai/copilot/`, `ai/claude/`, etc.) are registered globally with the AI tool — they are not stored in the PM Product folder. `create_prototype` always initializes and reads from `./prototypes/` relative to the current PM Product folder. No path configuration required.

### Remote

The prototype repo pushes to GitHub under the product line:

```
https://github.com/{org}/hyprlayer-prototypes-{product-slug}
```

The remote URL is set once when `./prototypes/` is first initialized and stored in `.git/config` — Hyprlayer reads it from there on subsequent runs.

### Folder structure

```
prototypes/                                 ← git repo root
├── package.json                            ← pnpm workspace root
├── pnpm-workspace.yaml
├── README.md
├── .gitignore
└── {feature-slug}/                         ← one folder per prototype, scaffolded via shadcn preset
    ├── src/
    │   ├── screens/
    │   ├── components/ui/
    │   ├── data/
    │   ├── types/
    │   ├── hooks/
    │   ├── lib/
    │   └── store/                          ← only if Zustand is needed
    ├── handoff/                            ← vite build output (gitignored until published)
    ├── PROTOTYPE.md
    └── HANDOFF.md
```

### pnpm workspace

```yaml
packages:
  - '*'
```

This includes all `{feature-slug}/` directories as workspace packages.

---

## Naming conventions

| Thing | Convention | Example |
|-------|-----------|---------|
| Product slug | kebab-case | `bim-viewer`, `lbm` |
| Feature slug | kebab-case | `model-upload`, `cost-breakdown` |
| Repo name | `hyprlayer-prototypes-{product-slug}` | `hyprlayer-prototypes-bim-viewer` |
| Prototype path (within repo) | `{feature-slug}` | `model-upload` |
| Screen files | PascalCase.tsx | `UploadScreen.tsx`, `ReviewDashboard.tsx` |
| Mock data files | kebab-case.json | `project-list.json`, `cost-items.json` |
| Type files | kebab-case.types.ts | `project.types.ts` |
| Zustand stores | use-{noun}-store.ts | `use-cart-store.ts` |

---

## State Management

Apply in order — do not skip levels:

| Complexity | Approach | When to use |
|------------|----------|-------------|
| Local, single screen | `useState` / `useReducer` | Default for all screen-level state |
| Shared, 2–3 screens, simple | React Context | Shared filter state, theme, auth mock |
| Cross-screen, complex flows | Zustand | Multi-step workflows, global UI state, cart/session patterns |
| Never in prototypes | Redux | — |

**Zustand escalation rule:** Add Zustand only when the feature being prototyped genuinely requires cross-screen shared state that would result in prop-drilling 3+ levels through Context. When Zustand is added, log the reason in PROTOTYPE.md as a design decision.

**Install:** `pnpm add zustand` inside the prototype folder.  
**Store location:** `src/store/use-{noun}-store.ts`  
**Pattern:** One store per domain concern. No combined mega-stores.

---

## Data Layer

### Default: JSON mock data

All prototype data lives in `src/data/` as typed JSON files. No real API calls unless the feature being prototyped is specifically about API integration UX.

- One JSON file per entity domain, e.g. `projects.json`, `cost-items.json`
- TypeScript interfaces colocated in `src/types/{entity}.types.ts`
- Import data directly: `import projects from '@/data/projects.json'`
- Mock data must be realistic — use domain-appropriate values, not `"string"` or `123`

### PostgreSQL escalation criteria

Add a PostgreSQL database **only** when the spec explicitly requires one of:

1. **User authentication** — the prototype demonstrates multi-user login, roles, or permissions
2. **Multi-user data isolation** — data must differ per logged-in user
3. **Real-time persistence** — the prototype demonstrates data surviving a page refresh as a core feature
4. **Relational data complexity** — the feature's core interaction requires joins that cannot be plausibly mocked with flat JSON

When PostgreSQL is added, log the reason in PROTOTYPE.md.

---

## Component Patterns

- **Composition over configuration** — build screens from small, focused components
- **Flat component folder** — `src/components/` with clear naming; no atomic design hierarchy
- **Co-locate related logic** — hooks and types for a screen go in `src/hooks/` and `src/types/`, named to match their screen
- **No barrel files** — import directly from component files, not from an `index.ts`
- **No global CSS beyond index.css** — use Tailwind utility classes; keep `index.css` for Tailwind directives and CSS variable overrides only

---

## Routing

Use React Router v6 (`react-router-dom`) for multi-screen prototypes.

- Install: `pnpm add react-router-dom`
- Route per screen, defined in `App.tsx`
- Use `<Link>` and `useNavigate` — never `window.location`

---

## PROTOTYPE.md Schema

Every prototype has a `PROTOTYPE.md` at its root. Created on scaffold, updated on every screen addition or iteration.

```markdown
---
slug: {feature-slug}
product: {product-slug}
title: {Human-readable title}
status: in-progress | ready-for-handoff | archived
created: YYYY-MM-DD
prototype_path: {feature-slug}
repo: https://github.com/{org}/hyprlayer-prototypes-{product-slug}
spec: {relative path to spec in thoughts/, or empty}
prd: {relative path to PRD in thoughts/, or empty}
oa: {relative path to OA in thoughts/, or empty}
state_management: context | zustand
database: none | postgresql
---

# Prototype: {title}

## Screens

| Screen | File | Status | Notes |
|--------|------|--------|-------|

## Design Decisions

| Decision | Rationale | Captured to Memory |
|----------|-----------|:-----------------:|

## Mock Data

| Entity | File | Description |
|--------|------|-------------|

## Known Gaps

(Interactions, edge cases, or content that is not prototyped and should be noted for engineering)
```

---

## Thoughts Manifest Schema

A lightweight pointer file in `thoughts/shared/prototypes/`. This is what `@thoughts-locator` finds. The full `PROTOTYPE.md` lives in the prototype repo.

```markdown
---
slug: {feature-slug}
product: {product-slug}
title: {title}
status: in-progress | ready-for-handoff | archived
created: YYYY-MM-DD
prototype_path: {feature-slug}
repo: https://github.com/{org}/hyprlayer-prototypes-{product-slug}
spec: {path or empty}
prd: {path or empty}
---

# {title}

Brief one-paragraph description of what this prototype covers.
```

File path: `thoughts/shared/prototypes/{yyyy-mm-dd}-prototype-{feature-slug}.md`
