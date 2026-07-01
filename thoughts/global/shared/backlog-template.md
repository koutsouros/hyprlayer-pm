---
title: "Backlog: {{Product Name}}"
type: note
date: {{YYYY-MM-DD}}
status: active
ticket: ""
project: "{{product-slug}}"
scope: shared
tags: [backlog]
author: "{{author}}"
related: []
last_updated: {{YYYY-MM-DD}}
last_updated_by: "{{author}}"
---

# Backlog: {{Product Name}}

Single source of truth for all feature specs and their status. Updated automatically by `/create_spec`. Eng Plan links are added by `/create_plan`. Status updated to Done when a feature ships.

---

## Spec Registry

| Status | Feature | Spec | Eng Plan | Created | Notes |
|--------|---------|------|----------|---------|-------|
|        |         |      |          |         |       |

<!--
Status values:
  Todo        — spec written, not yet in an eng plan
  In Progress — eng plan exists, implementation underway
  Done        — shipped or closed
  Blocked     — waiting on something external (add blocker note in Notes column)

Eng Plan path is relative to this file: ../../repos/[project]/shared/plans/[plan-file].md
Spec path is relative to this file: ../specs/[spec-file].md
-->

---

## Parking Lot

Raw ideas not yet ready for a spec. No structure required within each section — just enough to not lose it. When an idea gets spec'd, remove it from here and add it to the Spec Registry above. The spec's `source` frontmatter field records which section and entry it came from.

### User Feedback
<!-- Ideas sourced from support tickets, NPS responses, user interviews, or in-app feedback.
     Include a signal count or reference where possible (e.g., "3 support tickets", "NPS batch June 2026"). -->

### Internal Ideas
<!-- Ideas from planning sessions, team discussions, or stakeholder requests.
     Include the originating meeting or person so the idea has an owner if it moves forward. -->

### Research & Metrics
<!-- Ideas surfaced from Opportunity Assessments or post-launch metrics reviews.
     Link to the source doc where possible (e.g., [see metrics doc](../metrics/YYYY-MM-DD-metrics-slug.md)). -->

### Competitive Signals
<!-- Gaps or opportunities identified from competitive analysis.
     Reference the OA or competitive brief that surfaced the signal. -->
