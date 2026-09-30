# Creator Dashboard — Claude/Xcode Handoff

This package is the source-of-truth handoff for building the **Creator Dashboard** iOS WidgetKit project.

## What Claude should open first

1. `spec/CLAUDE_BUILD_PROMPT.md`
2. `assets/reference/04-creator-dashboard-system-mockup.png`
3. `assets/reference/02-creator-mat-master.png`
4. `spec/DESIGN_TOKENS.json`
5. `spec/VISUAL_ACCEPTANCE_CHECKLIST.md`

## Critical instruction

The visual assets are **approved comps**, not loose inspiration. Claude should act as an implementation engineer, not a product designer.

The first deliverable is only:

**Creator Mat theme → Medium Widget → Static placeholder data → Simulator screenshot → visual comparison → STOP**

Do not connect Calendar, Weather, HealthKit, Location, APIs, AI, or any backend until the static widget is visually approved.

## Reference assets

- `00-current-vibe-reference.png` — original visual taste/reference supplied by Bradley.
- `01-editorial-vs-creator-mat-concept.png` — early two-theme direction.
- `02-creator-mat-master.png` — core green/orange cutting-mat visual language.
- `03-creator-mat-wide-master.png` — wide-format master/wallpaper direction.
- `04-creator-dashboard-system-mockup.png` — **PRIMARY UI REFERENCE** for widget layout and information hierarchy.

## Priority order

1. `04-creator-dashboard-system-mockup.png` — layout / module hierarchy
2. `02-creator-mat-master.png` — visual character / brand texture
3. `CLAUDE_BUILD_PROMPT.md` — behavior / implementation constraints
4. Apple platform constraints
5. Claude's judgment only where 1–4 provide no answer

## Target devices

- Primary: iPhone 17 Pro, medium WidgetKit widget
- Secondary later: iPad Air 4th generation

Do not hard-code screenshot pixel dimensions. Use responsive SwiftUI / WidgetKit layout behavior.

## Product identity

A small creative control panel built into a designer's cutting mat.

**Dark green + technical grid + signal orange + off-white typography + Swiss editorial hierarchy + drafting details + minimal rounding.**
