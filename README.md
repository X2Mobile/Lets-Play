# LET'S PLAY! (يلا نلعب)

Concept demo of **Let's Play Language!** — gamified Arabic literacy for kids (ages 5–12)
built around a LEGO-brick metaphor: children *construct* Arabic letters, tashkeel and
numbers from colored bricks, trace them, and match them to real recorded sounds, words
and dialogues.

**Pure concept MVP: no server, no auth, no payments.** Everything is hardcoded in
organized content files; real Arabic audio recordings, the brand logos and character
illustrations are bundled as assets. The UI follows the client's **2026-07 SVG design
drop** (`../design/` — folders `LEVEL 1`–`LEVEL 5`, `LOG IN`, `PROFILE`), which
supersedes the original Adobe XD prototypes. The distilled design system and palette
live in `DESIGN_SPEC.md`.

---

## How to run

```bash
flutter pub get
flutter run          # any iOS simulator / Android emulator / device (portrait phones)
```

Turn sound ON — the audio buttons play the client's real Arabic recordings.

---

## What's implemented — screen by screen

### 1. Splash — LEGO cascade
Colored LEGO bricks rain down and tile the yellow screen column by column
(design LOG IN/0–3), then a crimson frame reveals the yellow LET'S PLAY brick logo
(LOG IN/4). Auto-advances to Login after ~4 s. *Nothing to tap.*

### 2. Login — visual only
Blue background, `Login` heading + prototype subtitle, email/password fields (typing
works, nothing is validated), `Remember me` checkbox, `Forgot your password?` / social
icons (decorative).
**Test:** tap `Sign in`, `Login with Facebook`, or `Sign up` — all simply advance to
onboarding. No credentials needed.

### 3. Onboarding — "Tell us about yourself" (design LOG IN/7–13)
Four survey steps, each with its own colored question banner and the stud progress bar:
1. **Why have you chosen to study Arabic?** (blue banner, 2-column illustrated cards)
2. **What is your level of proficiency in Arabic?** (orange)
3. **What is your daily goal for learning Arabic?** (azure — 10/15/20/25 min/day with
   Casual→Intense labels)
4. **Which dialect of Arabic are you interested in?** (yellow)

Then three design interstitials: the **LetsPlay+ upsell** (royal blue, benefit cards —
X or CONTINUE both advance), **"Here's what you can accomplish!"** (three benefit
cards), and the **placement choice** ("Start from Scratch" / "Find my starting place" —
both lead on, concept only).

### 4. Plan loading
Sky-blue screen, "Finishing up your custom plan", bouncing LEGO brick. Auto-advances
to Home after ~2.5 s.

### 5. Home shell — bottom navigation (4 tabs, design PROFILE/…)
| Tab | Status |
|---|---|
| **Home** (house) | Level map — see below |
| **Total Points** (sparkle) | Design PROFILE/8: giant green live points over the LEGO castle world + "Look what your points got you!" physical rewards with progress bars |
| **Leaderboard** (crown) | Design PROFILE/5–6: LEGO podium with top-3 avatars, Leadership/Tournaments tabs, ranked list with the user highlighted |
| **Profile** (smiley) | Design PROFILE/1: avatar, Malak, joined date, Following/Followers, colored live Statistics cards, Review Progress + Find-your-Friends rows, gear → **Settings** (design PROFILE/2: account rows, sound-effects toggle, Sign Out) |

### 6. Home — the five level bands (design home map)
- **Stats bar**: ✦ XP · ❤ hearts · ⚡ energy (live) + green gear → Settings.
- **Level 1 (Letters, yellow)** — full alphabet grid + combined forms & hamza variants
  (لما لا ء أ إ ؤ ئ). **أ, ب, ت start unlocked**; أ and ب have full lessons.
- **Level 2 (Tashkeel, orange)** — tashkeel row; the **fatha (ـَ)** tile opens the full
  fatha lesson.
- **Level 3 (Numbers, blue)** — number tiles ١–١٠ and the hundreds to ١٠٠٠; **٢**
  opens the ithnan lesson.
- **Level 4 (Words, green)** — category cards (2/3/4/5-letter words); **"2 letter
  words"** opens the Word Types lesson.
- **Level 5 (Sentences, purple)** — phrase categories (Introduce Yourself, Directions,
  Travel, Restaurants); **"Introduce Yourself"** opens the greetings lesson.
- Locked tiles shake playfully with a snack.

### 7. Lesson chrome (every level, design LEVEL N/0–1 + final frame)
Every lesson runs: **Level intro** (mascot + white "Level N — You'll learn …" checklist
card, level color, X to exit) → **Lesson N countdown** (mascot with the ٣٢١ speech
bubble on a gradient) → exercises → **Level-up screen** ("N pt" plaque,
"Congratulations Malak! You've just leveled up!", Accuracy/Speed/Share cards) →
rewards granted, back Home with the next tile unlocked. Swipe-back is disabled
mid-flow; the X (with a "Wait, don't go!" confirm inside exercises) is the only exit —
including on the full-bleed tutorial/checkpoint interstitials.

### 8. Exercise types (shared across levels)
Build-the-letter drag&drop (with positional-form tabs, Baseline/Ascender guide line,
retry + ⏱/⚡/`Moves:` HUD, and — in Levels 2–3 only, per the design — the "Awesome! You
nailed it!" banner), trace-the-letter, press-to-reveal brick flashcards, letter-forms
reference, "Learn" teach cards (grammar/tashkeel, with per-row audio), single-choice
(true/false, fill-the-blank, pronunciation, classify, picture/word/transliteration
matches), multi-select ("choose all the Nouns"), form-the-sentence word tiles (RTL),
listen-to-the-dialogue (two characters with speech bubbles), repeat-what-you-heard
(animated fake mic — no real speech recognition), place-the-diacritic drag target, and
mascot tutorial/checkpoint interstitials. Wrong answers flash red, shake and cost a
heart (never below 1 — the demo can't dead-end).

### 9. Lesson content per level
| Level | Lesson | Highlights |
|---|---|---|
| 1 | **أ Alef** (+ **ب Baa**) | tutorial → build with form tabs → press-reveal → letter forms → trace → checkpoint → listen/true-false/speak/picture-word drills → form-the-word |
| 2 | **Fatha** | build the ascender staircase → fatha card → كَ/لَ flashcards → pronunciation quizzes → place the fatha → أكَلَ speaking + breakdown → match the mark |
| 3 | **٢ Ithnan** | build the brick numeral → اثنان card → press-reveal → rebuild → true/false ×2 → match/count/listen → trace → pronounce |
| 4 | **Word Types** | teach-then-drill grammar: اسم/فعل/حرف, noun types & signs, verb tenses, imperative, 7-sentence conjugation battery, classify |
| 5 | **Introduce Yourself** | listen to the أنا أعيش في مصر dialogue → form its question → choose-what-you-hear → build أهلاً صباح الخير → fill the blank → rearrange |

---

## Suggested client demo script (~5 minutes)

1. Launch → watch the brick-cascade splash → tap **Sign in**.
2. Answer the 4 survey questions → skim the upsell / accomplish / placement screens.
3. On Home, scroll all five level bands — point out Numbers/Words/Sentences now have
   real content; tap a locked tile (shake).
4. Tap **أ** → full Level-1 flow: intro, countdown, build with form tabs, trace,
   checkpoint, quizzes (get one wrong to show heart loss), level-up screen, updated XP.
5. Tap the **fatha** tile → Level-2 lesson (staircase build + "Awesome!" banner,
   place-the-fatha, speaking exercise).
6. Tap **٢** (Level 3), **"2 letter words"** (Level 4) or **"Introduce Yourself"**
   (Level 5) for the other flows.
7. Finish on the tabs: Total Points castle, Leaderboard podium, Profile + Settings.

## What is intentionally NOT functional

- Login is a facade — no validation, no accounts; upsell/placement choices don't branch.
- Onboarding answers don't change the plan (concept only).
- Only the first tile of each level has a lesson; other tiles → "coming soon"/locked.
- No recordings exist for: أكَلَ, the Level-5 dialogue lines, أنا اسمي سارة/آدم — those
  steps run silently; Level-5 greeting drills reuse `sabah_alkhair.mp3`.
- Mic exercises animate but do no speech recognition (Azure Speech is out of MVP scope).
- Profile numbers (Following/Followers, leaderboard names) and Settings rows are static;
  Help Center / Feedback / followers popup are "coming soon".
- Progress lives in memory only — restarting the app resets XP/hearts/unlocks.
- Design typos were deliberately fixed in-app ("Congratutlations" → Congratulations,
  "You''ll learn", حماد → جماد, "intteruptions") — flag to the client.

---

## Content & asset inventory (all hardcoded / bundled)

- `lib/data/content/` — the single source of truth: `letters_content.dart`,
  `levels_content.dart` (5 bands + tashkeel/numbers/category tiles),
  `lesson_alef/baa/fatha/ithnan/word_types/greetings.dart` (full exercise sequences),
  `lessons_content.dart` (lookup), `onboarding_content.dart` (survey + upsell +
  accomplish + placement copy), `placeholders_content.dart` (profile section),
  `ui_strings.dart`.
- `assets/audio/` — 21 real client recordings (letters, words, numbers, greetings).
- `assets/images/characters/` — 13 mascot crops extracted from the design SVGs
  (level intros, ٣٢١ countdowns, tutorial banner, checkpoint, celebration).
- `assets/images/illustrations/` — 16 crops (dialogue speakers, exercise pictures,
  leaderboard podium, points castle, rewards, avatar, upsell art).
- `assets/images/logo/` — 3 brand logos. `assets/fonts/` — Baloo Bhaijaan 2 (400–800).

## Architecture

```
lib/
  main.dart / app.dart          # bootstrap, theme, provider wiring
  core/
    theme/                      # LpColors (XD palette + 2026-07 level colors),
                                # text styles, ThemeData
    widgets/                    # design system: LpButton, LpCard, OptionTile,
                                # StudProgressBar, StatsBar, BrickWidget/BrickGlyph,
                                # BaseplateBackground, AudioButton, HeartCounter,
                                # ExerciseTopBar, MascotImage, LpIcons, LpLogo
    services/audio_service.dart # audioplayers wrapper (asset play + slow rate)
  data/
    models/                     # Letter, LevelSection/LevelCategory, Lesson,
                                # 16 sealed Exercise variants, OnboardingQuestion,
                                # UserProgress
    content/                    # ALL hardcoded content (see inventory above)
  state/app_state.dart          # ChangeNotifier: xp, hearts, energy, unlocks,
                                # completeLesson() → rewards + next-letter unlock
  features/
    splash/ auth/ onboarding/   # brick-cascade splash, login, survey + upsell/
                                # accomplish/placement, plan loading
    home/                       # main shell (bottom nav), level-map home, profile,
                                # leaderboard, total points, settings
    lesson/                     # level intro + countdown + level-up chrome,
                                # lesson flow host, 15 exercise pages, shared UI
```

- State: `provider` + `ChangeNotifier` — deliberately light for a serverless demo.
- Design language: "neo-brutalist toy" — hard zero-blur shadows, 2.5–3 px black
  borders, brand palette, custom-painted bricks/icons. No stock Material widgets.
- `flutter analyze` is clean; web release build compiles; the app runs on
  iOS / Android / web.
