---
name: pickem-weekly
description: Capture this week's 4 Yahoo Pigskin Pick'em screenshots, draft recap/hype blurbs and shareable captions, update the season README, and stage a commit for review. Use when the user wants to process a week's pick'em results (e.g. "/pickem-weekly week-03", "do this week's pickem recap", "update the pickem README for this week").
---

# Pigskin Pick'em weekly recap

Turns one week of Yahoo Pigskin Pick'em group picks into: a README update, a few
recap/hype blurb options, and a couple of snarky captions to share with friends.

Read the repo's `CLAUDE.md` first if you haven't already this session — it defines
branch naming, PR title conventions, and the exact season/week folder structure this
skill must not violate.

## Inputs

Figure out season + week from the user's message, or ask if ambiguous:
- Season directory: e.g. `2026-27`. Default to the newest season directory that has a
  `README.md` already populated with weeks (skip an empty just-created season dir).
- Week folder: e.g. `week-03`, or a postseason round
  (`postseason-wildcard`, `postseason-divisional`, `postseason-conference-championship`,
  `postseason-super-bowl`).
- Look up that season's Yahoo group ID from its `README.md` (the `Group ID:` line) to
  build URLs, e.g. `https://football.fantasysports.yahoo.com/pickem/<groupId>/...`.

## Step 1 — Get the 4 screenshots

Check the week folder first: if `01.png`–`04.png` already exist, skip straight to Step 2.

Otherwise, capture them live using **Claude in Chrome** (the user's real, already-logged-in
browser) — never the sandboxed in-app Browser pane, since that has no Yahoo session, and
never attempt to log in on the user's behalf.

1. Load the Chrome tools if deferred: `ToolSearch` with
   `select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__tabs_close_mcp`.
2. Navigate to the group picks page for the target week, e.g.
   `https://football.fantasysports.yahoo.com/pickem/<groupId>/grouppicks?week=<N>`.
3. If the page shows a Yahoo login/sign-in prompt instead of pick'em data, stop and tell
   the user to log into Yahoo in their own Chrome first — do not enter credentials.
4. The site's own nav/tabs on that page should get you to the other 3 views (standings,
   weekly performance, my picks). The exact tab labels/URLs aren't hardcoded here because
   Yahoo's UI can shift — inspect the page (`read_page`) to find them rather than guessing
   query params.
5. Screenshot each view and crop out browser chrome / unrelated page furniture so only the
   pick'em content remains, matching what past weeks' `01.png`–`04.png` look like (open one
   from last week as a reference before cropping).
6. Save in this fixed order — do not deviate, per `CLAUDE.md`:
   - `01.png` — Standings
   - `02.png` — Group picks
   - `03.png` — Weekly performance
   - `04.png` — My picks

## Step 2 — Read the results

Read all 4 saved images (vision) to extract:
- This week's winner(s), or a tie and who's tied.
- Any notable/contrarian picks or upsets visible in the group picks grid.
- Current season standings leader and how tight the race is.
- Whether next week's picks are already open (relevant for the "week ahead" blurb).

## Step 3 — Draft blurbs (present as options, don't auto-pick)

Generate and show the user:
- **3–5 recap blurb options** for the week just finished — congratulating the winner, or
  calling out a tie, plus a short summary of what happened. Vary tone across the options
  (straightforward → lightly snarky) so the user can pick a favorite or mix-and-match.
- **1 "week ahead" blurb** encouraging the group to get picks in soon for next week.
- **A couple of short, punchier caption options** (1–2 sentences, a bit more snark) sized
  to paste alongside a screenshot when sharing in Messenger/iMessage. These are text only —
  no generated graphic yet; that's a possible future enhancement, don't attempt it now.

Wait for the user to pick/edit before writing anything to the README.

## Step 4 — Update the season README

Follow the existing file's format **exactly** — check `2025-26/README.md` for the pattern
if unsure:
- Section header: `### Week NN` (zero-padded, e.g. `Week 03`) or
  `### Postseason - <Round Name> (Week X of 4)` for postseason.
- Four image embeds directly under the header:
  `![ ](./week-NN/01.png)` ... `04.png`.
- Insert the new section in the existing reverse-chronological order (newest week/round
  at the top, right after any later postseason sections, before older weeks) — don't
  append at the end or re-sort existing sections.
- Do not touch the `01.png`–`04.png` naming convention note or the group ID/password/URL
  block elsewhere in the file.

If this is the season's first-ever week, also check whether the root `README.md`'s
"this year's pick'em" pointer needs updating (per `CLAUDE.md`).

## Step 5 — Stage git changes, then stop

Per `CLAUDE.md`'s git workflow:
1. Create a branch named `YYYY.MM.DD/add-<week-or-round>-screenshots`, dated with the
   real `date` command (never hand-typed).
2. Stage the new screenshots and the README change.
3. Commit with a conventional-commit message, e.g. `feat: add week 03 screenshots`.
4. **Stop here.** Show the user the diff/commit and ask for explicit confirmation before
   pushing or opening a PR — never push or run `gh pr create` without that confirmation,
   even if this skill was invoked as part of a routine/scheduled reminder.

## Notes

- This skill is meant to be run interactively (you're present to grant Chrome access and
  approve the push/PR) — it is not meant to run unattended in a background/cloud schedule.
- Never fabricate scores, picks, or standings if a screenshot is unclear — say so and ask
  the user rather than guessing.
