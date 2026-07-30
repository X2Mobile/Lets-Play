# LET'S PLAY! (يلا نلعب)

Concept demo of **Let's Play Language!** — gamified Arabic literacy for kids (ages 5–12)
built around a LEGO-brick metaphor: children *construct* Arabic letters from colored
bricks, trace them, and match them to real recorded sounds and words.

**Pure concept MVP: no server, no auth, no payments.** Everything is hardcoded in
organized content files; real Arabic audio recordings and the brand logos are bundled
as assets. The design follows the client's Adobe XD prototypes and prototype videos —
the distilled design system, palette and flow specs live in `DESIGN_SPEC.md`.

---

## How to run

```bash
flutter pub get
flutter run          # any iOS simulator / Android emulator / device (portrait phones)
```

Turn sound ON — the audio buttons play the client's real Arabic recordings.

---

## What's implemented — screen by screen

### 1. Splash
Royal-blue screen with the yellow block-wordmark logo (scale-in animation).
Auto-advances after ~1.5 s. *Nothing to tap.*

### 2. Login — visual only
Faithful to the XD prototype: blue background, `Login` heading + prototype subtitle,
email/password fields (typing works, nothing is validated), `Remember me` checkbox
(toggles), `Forgot your password?` / social icons (decorative).
**Test:** tap `Sign in`, `Login with Facebook`, or `Sign up` — all simply advance to
onboarding. No credentials needed.

### 3. Onboarding — "Tell us about yourself"
4 questions, each a yellow question card + gray option tiles. Tapping an option
highlights it yellow and auto-advances after ~350 ms; the stud progress bar fills.
The back chevron returns to the previous question. Answers are stored in app state
(not used further — concept only). Questions (in `data/content/onboarding_content.dart`):
1. Which dialect of Arabic are you interested in? (Levantine / Egyptian / Gulf / MSA)
2. How old is the learner?
3. How much Arabic do they know?
4. What's your daily goal?

### 4. Plan loading
Sky-blue screen, white "LET'S PLAY! / يلا نلعب" chip, "Finishing up your custom plan",
bouncing LEGO brick animation. Auto-advances to Home after ~2.5 s.

### 5. Home shell — bottom navigation (4 tabs)
| Tab | Status |
|---|---|
| **Home** (house) | Fully functional — see below |
| **Quests** (sparkle) | Polished placeholder: "Daily Quests" list with progress bars (Earn 50 ✦ · Finish 1 lesson · Practice 5 minutes) |
| **Leaderboard** (crown) | Polished placeholder: "Yellow League" ranking (Layla, Omar, **You**, Sara, Adam) |
| **Profile** (smiley) | Polished placeholder: avatar card "Little Builder", live XP/hearts/energy stats, 3-day streak |

### 6. Home
- **Stats bar**: ✦ XP · ❤ hearts · ⚡ energy (all live from app state) + green settings
  gear (shows a "coming soon" snack).
- **Level 1 (Letters)** — yellow header card + the full 28-letter Arabic alphabet grid
  (Arabic glyph + transliteration). **أ, ب, ت start unlocked** (yellow); the rest are
  locked (gray).
  - Tap **أ** or **ب** → starts that letter's lesson (the core demo).
  - Tap **ت** → "This lesson is coming soon!" snack (content exists for أ/ب only).
  - Tap a locked tile → playful shake + "Finish the previous letters…" snack.
- **Level 2 (Tashkeel)** — orange header card + tashkeel tile row. The **fatha (ـَ)**
  tile is unlocked: tapping it opens the **Fatha info screen** (orange brick staircase
  above the green "Ascender" baseline, audio auto-plays `فتحة`, orange card
  `فتحه (FAT-HAH) Letter+a`, CONTINUE enables after the audio) — matches the fat7a
  prototype video. Locked tashkeel tiles → snack.
- **Levels 3–5 (Words / Sentences / Conversations)** — blue/purple/green header cards
  with locked tile rows. Teasers only; nothing opens (by design).

### 7. Lesson flow — the core demo (letters أ and ب)
Top bar: **X** (opens a brand-style "Wait, don't go!" confirm dialog — Keep learning /
Quit lesson; system back does the same) · ❤ hearts · stud progress bar that fills as
you complete exercises. Five exercises in sequence:

1. **Letter intro** — big yellow card (letter, Arabic name, transliteration), audio
   auto-plays and can be replayed. CONTINUE → next.
2. **Build the letter** ⭐ signature interaction — LEGO baseplate with ghost outline
   slots forming the letter; drag the 4 bricks from the tray into the outline.
   Bricks snap into any empty slot of the same shape when dropped close; a miss glides
   back to the tray. Bottom bar: retry (resets), ⏱ cosmetic countdown, ⚡ energy,
   `Moves:` counter (decrements per drag, cosmetic — no fail state).
   Fill all slots → letter "pops" → auto-advance.
3. **Trace the letter** — the letter rendered from bricks; put your finger on the
   pulsing blue dot (👆 hint) and follow the stroke — a royal-blue line follows you.
   Forgiving hit radius; retry resets. Complete → pop → auto-advance.
4. **Match the image** — Arabic word card + audio (auto-plays), 3 emoji option cards.
   Correct → green flash, CONTINUE turns yellow. **Wrong → red flash + shake and you
   lose a heart** (hearts never drop below 1, so the demo can't dead-end).
5. **Choose what you heard** — big audio button + 🐌 snail button (replays the same
   clip at 0.6× speed), 2×2 option grid (emoji + a letter card). Same right/wrong
   behavior as above.

**Lesson complete** — brick confetti in brand colors, letter badge, animated
`✦ +120` and `⚡ +10` tallies, CONTINUE → back Home where the stats bar has updated
and **the next letter tile has unlocked** (finish أ → ث unlocks, etc.).

Lesson content:
| | Intro | Build/Trace | Match | Listen |
|---|---|---|---|---|
| **أ (Alef)** | ألف + audio | brick Alef | أب "father" (👨 🐰 🦁) | أسد "lion" (🦁 👨 🐰 أ) |
| **ب (Baa)** | باء + audio | brick Baa | بطة "duck" (🦆 🚪 🐄) | باب "door" (🚪 🦆 🐄 ب) |

---

## Suggested client demo script (~3 minutes)

1. Launch → watch splash → tap **Sign in**.
2. Answer the 4 onboarding questions → enjoy the plan-loading screen.
3. On Home, scroll the 5 level sections; tap a locked letter (shake), tap the
   **fatha** tile (tashkeel demo with audio), tap the gear (snack).
4. Tap **أ** → play the full lesson: listen to the letter, **build it from bricks**,
   **trace it**, answer the two quizzes (get one wrong on purpose to show the
   heart-loss feedback), celebrate, and point out the updated XP + newly unlocked
   letter on Home.
5. Tap **ب** for a second full lesson, then show the Quests / Leaderboard / Profile tabs.

## What is intentionally NOT functional

- Login is a facade — no validation, no accounts.
- Onboarding answers don't change the plan (concept only).
- ت and all gray tiles / Levels 3–5 have no lesson content yet.
- Settings gear, social login icons, quests/leaderboard data = static placeholders.
- Progress lives in memory only — restarting the app resets XP/hearts/unlocks.
- No speech recognition (the PRD's Azure Speech feature is out of MVP scope).

---

## Content & asset inventory (all hardcoded / bundled)

- `lib/data/content/` — the single source of truth for everything shown:
  `letters_content.dart` (28 letters + transliterations), `levels_content.dart`
  (5 level sections + tashkeel row + fatha copy), `lesson_alef.dart` /
  `lesson_baa.dart` (full exercise sequences incl. brick layouts & trace paths),
  `lessons_content.dart` (lookup), `onboarding_content.dart`,
  `placeholders_content.dart`, `ui_strings.dart`.
- `assets/audio/` — 9 real client recordings: `alef, ab_father, arnab_rabbit,
  asad_lion, baa, batta_duck, bab_door, baqara_cow, fatha` (.mp3).
- `assets/images/logo/` — 3 brand logos from the client package.
- `assets/fonts/` — Baloo Bhaijaan 2 (Arabic + Latin), weights 400–800.

## Architecture

```
lib/
  main.dart / app.dart          # bootstrap, theme, provider wiring
  core/
    theme/                      # LpColors (XD palette), text styles, ThemeData
    widgets/                    # design system: LpButton, LpCard, OptionTile,
                                # StudProgressBar, StatsBar, BrickWidget/BrickPainter,
                                # BaseplateBackground, AudioButton, HeartCounter,
                                # ExerciseTopBar, LpIcons (custom-painted), LpLogo
    services/audio_service.dart # audioplayers wrapper (asset play + slow rate)
  data/
    models/                     # Letter, LevelSection, Lesson, sealed Exercise
                                # variants, OnboardingQuestion, UserProgress
    content/                    # ALL hardcoded content (see inventory above)
  state/app_state.dart          # ChangeNotifier: xp, hearts, energy, unlocks,
                                # completeLesson() → rewards + next-letter unlock
  features/
    splash/ auth/ onboarding/   # splash, login, questions + plan loading
    home/                       # main shell (bottom nav), home, fatha info,
                                # quests / leaderboard / profile placeholders
    lesson/                     # lesson flow host, 5 exercise widgets,
                                # complete screen, shared lesson UI
```

- State: `provider` + `ChangeNotifier` — deliberately light for a serverless demo.
- Design language: "neo-brutalist toy" — hard zero-blur shadows, 2.5–3 px black
  borders, brand palette, custom-painted bricks/icons. No stock Material widgets.
- `flutter analyze` is clean; web release build compiles; the app runs on
  iOS / Android / web.
