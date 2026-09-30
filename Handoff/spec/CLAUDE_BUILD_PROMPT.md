# CREATOR DASHBOARD
## FINAL IMPLEMENTATION BRIEF — LOCKED VISUAL SYSTEM

You are implementing an already-approved iOS widget design.

You are **not designing a new interface**. You are **not exploring alternatives**. You are **not improving the approved design**.

Your job is to faithfully reproduce the supplied visual system in **SwiftUI + WidgetKit**.

---

# 0 — LOCKED DESIGN CONTRACT

The supplied visual assets are not inspiration. They are approved comps.

**Pixel-level visual fidelity is the goal.**

You do NOT have authority to:
- alter layout proportions
- move sections
- add/remove sections
- change typography hierarchy
- change colors
- change wording
- change grid density/style
- substitute generic components
- "make it more native"
- "improve UX"
- simplify the design
- introduce a new design system

If an actual Apple/WidgetKit limitation prevents faithful reproduction, **stop and explain the limitation before changing the design**.

### Reference priority order
1. `assets/reference/04-creator-dashboard-system-mockup.png` — visual/layout truth
2. `assets/reference/02-creator-mat-master.png` — visual character/texture truth
3. This specification — behavior/technical truth
4. Apple platform requirements
5. Your judgment only where 1–4 provide no answer

### Absolute visual gate
Do **not** implement EventKit, WeatherKit, HealthKit, Core Location, App Intents, dynamic focus logic, APIs, AI, or backend work until the static widget has been built, screenshotted, compared to the approved reference, and approved.

First deliverable only:

**Creator Mat → Medium Widget → Placeholder Data → Simulator Screenshot → Visual Comparison → STOP**

When in doubt: **ask. Do not design.**

---

# 1 — PRIMARY TARGET

- Product name: **Creator Dashboard**
- Primary device: **iPhone 17 Pro**
- Primary widget family: **WidgetKit medium**
- Secondary later: **iPad Air 4th generation**

Use responsive SwiftUI/WidgetKit layout. Do not hard-code screenshot pixel dimensions.

---

# 2 — CORE AESTHETIC

The interface should feel like:

**CREATOR CUTTING MAT × SWISS EDITORIAL DESIGN × INDUSTRIAL DRAFTING SYSTEM × RETRO TECHNICAL INTERFACE**

It should feel like a small technical instrument panel integrated into a designer's cutting mat.

It must NOT feel like:
- generic AI dashboard
- Apple Fitness clone
- Notion/Linear clone
- SaaS dashboard
- wellness app
- fintech app
- neon/futuristic UI

---

# 3 — STRICT ANTI-AI-SLOP RULES

DO NOT USE:
- generic rounded cards
- excessive corner radii
- glassmorphism
- frosted materials
- blur cards
- gradients
- glow effects
- floating cards
- colorful shadows
- pill-shaped UI everywhere
- giant SF Symbols
- charts/rings/streaks/badges
- gamification
- emojis
- productivity/wellness scores
- "Good morning, Bradley"
- AI-generated motivational copy
- generic dark-mode dashboard styling
- arbitrary animation

If it could plausibly come from a generic "AI productivity dashboard" prompt, it is wrong.

---

# 4 — DESIGN TOKENS

Use `spec/DESIGN_TOKENS.json` as the centralized source.

Core colors:

```text
MAT_GREEN      #0E2F24
SIGNAL_ORANGE  #FF3B0F
PAPER          #F4F1E9
GRID_GREEN     #2D4F42
MUTED_LINE     #9AA49D
```

Orange is a signal color, not a general decoration color.

Do not introduce blue, purple, or additional accent colors.

---

# 5 — CUTTING MAT BACKGROUND

Create reusable SwiftUI component:

```swift
CuttingMatBackground
```

It must support:
- dark matte green surface
- major grid
- minor grid
- measurement ticks
- subtle rulers
- registration marks
- construction lines
- occasional crosshair
- restrained technical texture

The grid must remain subordinate to content.

Do not make it bright. Do not make it ordinary graph paper. Do not fill empty space with meaningless fake technical noise.

---

# 6 — TYPOGRAPHY

Typography is the primary visual design element.

Preferred character:
- Helvetica Neue
- Inter
- Space Grotesk
- similar neutral grotesk sans serif

Use native/system typography where required, but tune:
- weight
- tracking
- line height
- scale
- hierarchy

Use dramatic size contrast instead of decorative UI.

Examples:

Small label:
```text
DON'T FORGET
```

Large value:
```text
9:30 AM
```

Hero:
```text
WHO ARE YOU
GOING TO BE
TODAY?
```

`TODAY?` uses SIGNAL_ORANGE in hero/calm state.

---

# 7 — WIDGET INFORMATION ARCHITECTURE

The medium widget contains exactly these areas:

1. Calendar strip
2. Weather
3. Next event
4. Sleep
5. Steps
6. Don't Forget
7. KK / Family
8. Quote strip
9. Capture control

Do not add anything else.

---

## A — CALENDAR STRIP

Top-left.

Example:
```text
SEP
28   29   [30]   01   02   03   04
```

Today uses SIGNAL_ORANGE as a compact square/rectangular signal block.

**Not a rounded pill.**

---

## B — WEATHER

Top-right.

Example:
```text
LOS ANGELES
72°
H: 78°   L: 58°
```

Temperature is dominant. A restrained condition icon is allowed but must not become the focal point.

---

## C — NEXT EVENT

Middle-left.

Example:
```text
NEXT
9:30 AM
NBS TEAM
→
```

Only show the next event. Never a full agenda.

---

## D — BODY

Middle-right.

Two metrics:
```text
6H 42M
SLEEP
```

and
```text
4,821
STEPS
```

Simple technical icons may accompany values. Numbers matter more than icons.

---

## E — DON'T FORGET

Lower-left.

```text
DON'T FORGET
● Call Mom re: Kia key
```

Orange signal dot allowed.

For V1 this is manually entered/shared placeholder data. Do not generate it with AI.

---

## F — KK / FAMILY

Lower-right.

```text
KK / FAMILY
Cheer 4:30 PM →
```

For V1 this is manually entered/shared placeholder data. Do not invent family information.

---

## G — QUOTE STRIP

Full-width bottom region.

Default:
```text
WHO ARE YOU GOING TO BE TODAY?
```

This is part of the product identity, not filler.

Hero/calm state:
```text
WHO ARE YOU
GOING TO BE
TODAY?
```

`TODAY?` uses SIGNAL_ORANGE.

Do not rewrite the quote.

---

## H — CAPTURE

Small outlined circular `+` near bottom-right.

It should feel like a restrained technical control, not a giant floating action button.

V1 may render it statically.

---

# 8 — INTERNAL GEOMETRY

Use:
- straight divider lines
- modular grid divisions
- square sections
- technical spacing
- thin rules

The widget is ONE constructed instrument panel.

Do not wrap every information group in a floating rounded rectangle.

Apple's outer widget mask may remain rounded. Internal structure should primarily use straight geometry.

---

# 9 — REQUIRED TECHNICAL DETAILS

Include restrained instances of:
- ruler/tick marks
- grid intersections
- technical crosshair
- registration mark
- construction line
- thin divider rules
- small directional arrows
- orange rectangular date highlight
- orange signal dot
- thin outlined circular plus control

These details should feel intentional, not decorative clutter.

---

# 10 — PLACEHOLDER DATA FOR STATIC BUILD

Use this exact first-pass data:

```text
SEP
28 29 30 01 02 03 04

LOS ANGELES
72°
H: 78°
L: 58°

NEXT
9:30 AM
NBS TEAM

6H 42M
SLEEP

4,821
STEPS

DON'T FORGET
Call Mom re: Kia key

KK / FAMILY
Cheer 4:30 PM

WHO ARE YOU GOING TO BE TODAY?
```

---

# 11 — THEME ARCHITECTURE

Structure from the beginning:

```swift
enum DashboardTheme {
    case creatorMat
    case editorial
}
```

But for the first visual build, fully implement **Creator Mat only**.

Do not spend time implementing Editorial until Creator Mat is visually approved.

---

# 12 — CODE ORGANIZATION

Suggested structure:

```text
CreatorDashboard/
    App/
        CreatorDashboardApp.swift
        ContentView.swift

    DesignSystem/
        DashboardColors.swift
        DashboardTypography.swift
        DashboardSpacing.swift
        CuttingMatBackground.swift
        GridOverlay.swift
        TechnicalRule.swift
        RegistrationMark.swift

    Models/
        DashboardSnapshot.swift

    Widget/
        CreatorDashboardWidget.swift
        DashboardTimelineProvider.swift
        DashboardWidgetView.swift

        Components/
            CalendarStrip.swift
            WeatherPanel.swift
            NextEventPanel.swift
            BodyMetricsPanel.swift
            DontForgetPanel.swift
            FamilyPanel.swift
            QuoteStrip.swift
            CaptureButton.swift
```

Keep components modular. Do not put the entire widget into one giant view.

---

# 13 — FIRST BUILD ORDER

Do not skip ahead.

1. Create SwiftUI iOS project
2. Add WidgetKit extension
3. Add design tokens
4. Implement typography system
5. Implement `CuttingMatBackground`
6. Implement static medium widget with exact placeholder data
7. Run in simulator
8. Capture screenshot
9. Compare screenshot against `assets/reference/04-creator-dashboard-system-mockup.png`
10. Revise visual discrepancies
11. Grade using `spec/VISUAL_ACCEPTANCE_CHECKLIST.md`
12. STOP and wait for approval

No live services before approval.

---

# 14 — FIRST DELIVERABLE RESPONSE

After the static build:

1. State files created/modified
2. Confirm whether project compiled
3. Provide simulator screenshot
4. List visible deviations from approved reference
5. Provide self-score out of 10
6. STOP

Do not continue automatically.

---

# 15 — FUTURE DATA SOURCES — ARCHITECTURE ONLY FOR NOW

Later phases may use:
- EventKit — next calendar event only
- WeatherKit — temperature/condition/high/low
- Core Location — weather location only
- HealthKit — sleep + steps
- App Groups — shared widget/app preferences
- Local quote string
- Manual Don't Forget value
- Manual KK / Family value

No external AI API in V1.

---

# 16 — FOCUS STATES — DO NOT IMPLEMENT YET

Approved future focus states:

### Event
```text
NEXT
23 MIN
NBS TEAM
```

### Sleep
```text
6H 42M
SLEEP
```

### Steps
```text
4,821
STEPS
```

### Calm
```text
WHO ARE YOU
GOING TO BE
TODAY?
```

The underlying visual system stays the same. Do not invent unrelated layouts.

---

# 17 — PERFORMANCE / DEPENDENCIES

For V1:
- native Apple frameworks only
- no UI packages
- no third-party design libraries
- no unnecessary animation
- no pseudo-live timer behavior
- lightweight grid drawing

---

# 18 — ANTI-AI-SLOP SELF-CHECK

Before declaring the first widget complete:

1. Does this look like a generic AI productivity dashboard? If yes, fix it.
2. Are there unnecessary rounded cards? Remove them.
3. Are there gradients, glass or glow? Remove them.
4. Is orange overused? Reduce it.
5. Are icons too prominent? Reduce them.
6. Does the cutting-mat grid feel physical and technical? If not, fix it.
7. Does the layout resemble Asset 04? If not, fix it.
8. Does the widget retain the character of Asset 02? If not, fix it.
9. Does the quote still carry visual/emotional weight? If not, increase its typographic importance.
10. Did you invent anything not explicitly requested? Remove it.

---

# 19 — FINAL DIRECTIVE

This is an implementation task, not a design exploration.

You are building:

**A SMALL CREATIVE CONTROL PANEL BUILT INTO A DESIGNER'S CUTTING MAT.**

The system is:

**DARK GREEN + TECHNICAL GRID + SIGNAL ORANGE + OFF-WHITE TYPOGRAPHY + SWISS EDITORIAL HIERARCHY + DRAFTING DETAILS + STRAIGHT MODULAR DIVISIONS + MINIMAL ROUNDING + NO AI SLOP**

Build the static Creator Mat medium widget first.

Match the references.

Compile it.

Run it.

Screenshot it.

Compare it.

Score it.

Then **STOP and wait for approval**.
