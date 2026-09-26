---
title: "Spec: {{Feature Name}}"
type: plan
date: {{YYYY-MM-DD}}
status: draft
ticket: ""
project: "{{product-slug}}"
scope: shared
tags: [spec]
author: "{{author name from thoughts status}}"
related: []
prd: "{{path to PRD in thoughts, or none}}"
prd_aligned: {{true | false}}
source: "{{parking lot section and entry if promoted from backlog, or none}}"
version: v0.1
---

# Spec: {{Feature Name}}

**Date:** {{YYYY-MM-DD}}
**Status:** Draft
**Author:** {{author}}
**PRD:** {{link to PRD in thoughts, or "Not yet in PRD"}}
**Related Specs:** {{links to related specs, or "none"}}

---

## Problem

{{One sentence. What user pain or product gap does this address?
Do not describe the solution here. Focus on the problem.}}

---

## User Story

As a {{persona — link to PRD persona or global/shared/personas/ if defined}},
I want to {{specific action or capability}},
so that {{measurable or meaningful outcome for the user}}.

---

## In Scope

{{3–5 items. Verb-first: "Allow users to…", "Surface…", "Support…", "Enable…"}}

- {{scope item}}

---

## Out of Scope

{{Explicit exclusions. Prevents scope creep in the implementation plan.}}

- {{out-of-scope item}}

---

## Acceptance Criteria

{{Testable Given/When/Then statements. These become /create_plan success criteria.}}

- **Given** {{condition}}, **when** {{action}}, **then** {{outcome}}.

---

## Success Metrics

{{1–2 measurable outcomes. Baseline if known. Rolls up to PRD metrics where possible.}}

- **{{Metric name}}:** {{What it measures}}. Baseline: {{value or [TBD]}}. Target: {{goal}}.

---

## Constraints

{{Optional. Confirmed technical, legal, or platform constraints only.}}

---

## Related Context

- **Opportunity Assessment:** {{path in thoughts, or "none found"}}
- **PRD:** {{path in thoughts, or "none found"}}
- **Backlog item(s):** {{parking lot section and entry text if promoted, or "none"}}
- **User documentation:** {{path to relevant user-docs file, or "none"}}
- **Prior specs:** {{paths to related specs, or "none"}}

---

## Open Questions

{{Each with an owner. Omit section if none.}}

- {{Question}} — Owner: {{name or team}}
