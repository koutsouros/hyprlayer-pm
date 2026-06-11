# Artifact Hierarchy

The PM layer produces four types of artifacts, each at a different scope. Understanding which one you need — and what it feeds — prevents the most common source of wasted work.

---

## The Four Levels

```
Opportunity Assessment (OA)
        ↓
Product Requirements Document (PRD)
        ↓
Feature Spec
        ↓
Engineering Plan  ← HyprLayer engineering workflow begins here
```

Each level inherits from the level above. A spec doesn't redefine personas — it references them from the PRD. An engineering plan doesn't re-state acceptance criteria — it imports them from the spec.

---

## Opportunity Assessment (OA)

**Produced by:** `research_opportunity`  
**Lives at:** `thoughts/shared/research/YYYY-MM-DD-opportunity-{slug}.md`  
**Scope:** Problem space and market context  
**Frequency:** Once per problem area, occasionally updated

The OA answers: *Is this worth solving? For whom? Against what alternatives?*

It synthesizes market signals, competitive landscape, customer evidence, and business context across parallel research agents. It doesn't prescribe features — it characterizes the opportunity.

**Use it when** you're entering a new problem space, justifying a new product, or need to ground a PRD in validated market context. Skip it when the opportunity is already well-understood and the team has alignment on the problem.

**Feeds into:** PRD (validates the problem framing and user personas)

---

## Product Requirements Document (PRD)

**Produced by:** `research_requirements`  
**Lives at:** `thoughts/shared/requirements/YYYY-MM-DD-prd-{slug}.md`  
**Scope:** Entire product — personas, roadmap, functional requirements, success metrics  
**Frequency:** One per product; updated as the product evolves

The PRD answers: *What are we building, for whom, and how will we know it worked?*

It defines the user personas that all specs reference, the phased roadmap that organizes features, the functional requirements table that specs map back to, and the product-level success metrics that feature-level metrics roll up to.

**Use it when** you're starting a new product, onboarding a new team member, or realigning on scope after significant product changes. It's not re-written for every feature.

**Feeds into:** Specs (personas, roadmap phase alignment, success metric inheritance)

**When a spec is written:** The PRD receives a back-link to the spec if `prd_aligned: true` — so the PRD stays navigable as a map of everything that's been scoped.

---

## Feature Spec

**Produced by:** `/create_spec`  
**Lives at:** `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`  
**Scope:** Single feature or epic  
**Frequency:** One per feature; versioned in place as it evolves

The spec answers: *What exactly should this feature do, and how will we know it's done?*

It inherits context from the PRD (personas, constraints, success metric direction) and translates it into something an engineering agent can act on directly: a bounded problem statement, explicit scope, and testable acceptance criteria.

A spec is not a mini-PRD. If writing it requires redefining product goals or user personas, that's a PRD update — not a spec.

**Feeds into:** Engineering plan (acceptance criteria become planning constraints)

**Key spec fields:**

| Field | What it drives |
|-------|---------------|
| `prd_aligned` | Whether the PRD gets a back-link; whether it's flagged as net-new |
| `status` | Backlog registry status (draft → Todo; implemented → Done) |
| `source` | Records if promoted from a parking lot entry |
| Acceptance Criteria | Direct input to `/create_plan` success criteria |
| Out of Scope | Prevents scope creep; auto-logged to `decisions.md` |

---

## Engineering Plan

**Produced by:** `/create_plan` *(HyprLayer)*  
**Lives at:** `thoughts/repos/{project}/shared/plans/YYYY-MM-DD-{slug}.md`  
**Scope:** Technical implementation of a single spec  
**Frequency:** One per spec

The engineering plan answers: *How will we build it?*

This is where HyprLayer's engineering workflow takes over. The plan reads the spec's acceptance criteria and success metrics as constraints and produces the technical breakdown — component design, implementation steps, validation approach.

When the plan is written, it links back to the backlog registry row (status moves to In Progress automatically).

**PM interaction with the engineering plan:**
- The backlog row links to the plan so you can see where each feature stands
- Memory captures any significant technical decisions made during planning (if `/update_memory` is called or HyprLayer's memory hooks are active)

---

## Choosing the right artifact

| Situation | Artifact needed |
|-----------|----------------|
| Exploring a new problem space | OA |
| Defining a new product or major pivot | PRD |
| Scoping a feature for the next sprint | Spec |
| Turning a spec into an implementation plan | Engineering Plan *(HyprLayer)* |
| Redefining personas or success metrics | PRD update |
| Adding a feature not yet in the PRD | Spec with `prd_aligned: false`, then consider a PRD update |
| Parking an idea before it's ready to spec | Backlog parking lot |

---

## What does NOT belong in a spec

| This belongs in... | Not in the spec |
|-------------------|----------------|
| User personas | PRD |
| Multi-quarter roadmap | PRD |
| Market opportunity framing | OA |
| Technical approach and architecture | Engineering Plan |
| Ideas not yet ready to scope | Backlog parking lot |
| Cross-product design principles | `thoughts/global/shared/` |

Keeping these boundaries clean is what makes the handoff from PM to engineering fast and unambiguous.
