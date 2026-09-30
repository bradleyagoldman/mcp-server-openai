# Creator Dashboard

A Home Screen widget built from the Creator Dashboard handoff, in the Studio color way
(dark green, cream, signal orange) to match the "Who are you going to be today?" wallpaper.

Widget sizes: **Medium** (the approved layout) and **Large** (same layout with the quote as the
three-line hero, "today?" in orange).

## Install

1. Double-click **CreatorDashboard.xcodeproj**.
2. Click the blue **CreatorDashboard** icon at the top of the left sidebar.
3. For **each** target (**CreatorDashboard** and **CreatorDashboardWidget**): open
   **Signing & Capabilities**, check **Automatically manage signing**, and pick your **Team**.
4. Plug in your iPhone, choose it at the top of Xcode, press **Play** (Cmd+R).
5. In the app, tap **Allow** for Location, Calendar, Reminders and Health.
6. Add the widget: touch and hold the Home Screen, tap **Edit**, then **Add Widget**, search **Creator Dashboard**.
7. Touch and hold the widget, tap **Edit Widget** to change Theme, Font, Text Size and fallback notes.

To see it without a phone: pick an iPhone 17 Pro simulator and press Play. The app's first screen
shows the widget with the sample data from the spec. You can also open
`Widget/CreatorDashboardWidget.swift` and use Xcode's preview canvas.

## Where each part gets its data

| Area | Source |
|---|---|
| Calendar strip | Today's date |
| Weather | Your location + Open-Meteo (free, no key), °F |
| Next | Next timed event from the Calendar app (shows for 15 minutes after it starts) |
| Sleep | Health app, time asleep since 6 PM yesterday |
| Steps | Health app, today |
| Don't Forget | Your most urgent open reminder. The **+** on the widget adds one. Falls back to the text in Edit Widget. |
| KK / Family | Next event from any calendar with **Family** or **KK** in its name. Falls back to the text in Edit Widget. |
| Quote | Fixed: "Who are you going to be today?" |

## If something goes wrong

- **"Failed to register bundle identifier"**: change `com.nutritionbuiltstrength.creatordashboard`
  in both targets to something unique. The widget's ID must keep `.widget` on the end.
- **Any red error**: screenshot it and send it to Claude.
