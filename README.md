# LET'S PLAY! (يلا نلعب)

Concept demo of **Let's Play Language!** — gamified Arabic literacy for kids (ages 5–12)
built around a LEGO-brick metaphor: children *construct* Arabic letters, tashkeel and
numbers from colored bricks, trace them, and match them to real recorded sounds, words
and dialogues.

**Firebase Analytics** is wired in (project `let-s-play-52f6a`), so the demo reports live,
measurable usage — active users, sessions and retention out of the box, plus a
`level_finished` event that counts how many levels learners actually complete (tagged with
level, lesson and XP earned). See [Analytics](#analytics) for the event contract.

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

## Analytics

Firebase Analytics (`firebase_core` + `firebase_analytics`) reports against Firebase
project **`let-s-play-52f6a`**, app id `com.x2mobile.letsplaygame`. Native configs are
committed at `ios/Runner/GoogleService-Info.plist` and `android/app/google-services.json`;
the Dart-side values live in `lib/firebase_options.dart`.

Automatically collected — no code needed: **active users** (DAU/WAU/MAU), sessions,
session duration, retention, first_open, device/country breakdowns.

One custom event, logged from `LevelUpScreen.initState` (i.e. the moment the last exercise
is cleared, so it counts even if the learner never taps CONTINUE):

| Event | Parameters |
| --- | --- |
| `level_finished` | `lesson_id`, `lesson_name`, `level_number`, `lesson_number`, `xp_earned` |

Counting `level_finished` gives levels-completed totals; segmenting by `level_number`
shows where learners drop off across the five bands. Note that the parameters only become
reportable once registered as custom dimensions/metrics in GA4 (*Admin → Custom
definitions*) — the raw event count works immediately, the breakdowns do not.

`AnalyticsService` (`lib/core/services/analytics_service.dart`) is a no-op when Firebase
fails to initialise — an unregistered platform (web) or a missing native config disables
analytics instead of crashing the demo.

Collection is confirmed working — the first simulator run showed up as an active user in
the Firebase console. One gap: no Firebase **web** app is registered for the project, so
analytics is inert on the web build (the app itself still runs).

To watch events arrive in the console's DebugView:

```bash
# Android
adb shell setprop debug.firebase.analytics.app com.x2mobile.letsplaygame
# iOS — add -FIRAnalyticsDebugEnabled to Runner's scheme launch arguments in Xcode
```

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
  firebase_options.dart         # Firebase project config (Android + iOS)
  core/
    theme/                      # LpColors (XD palette + 2026-07 level colors),
                                # text styles, ThemeData
    widgets/                    # design system: LpButton, LpCard, OptionTile,
                                # StudProgressBar, StatsBar, BrickWidget/BrickGlyph,
                                # BaseplateBackground, AudioButton, HeartCounter,
                                # ExerciseTopBar, MascotImage, LpIcons, LpLogo
    services/                   # audio_service (audioplayers wrapper: asset play +
                                # slow rate), analytics_service (Firebase Analytics)
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
  iOS / Android / web. Firebase pushes the iOS minimum to **15.0** (was 13.0).
