# LET'S PLAY! (يلا نلعب) — Design & Product Spec for the Flutter MVP Demo

Source of truth: UNICEF PRD + Adobe XD prototypes + prototype videos in
`../x2 mobile x lets play/`. This file distills everything an implementer needs.

## 1. Product concept

"Let's Play Language!" teaches Arabic literacy to children (ages 5–12) through a
LEGO-block metaphor: every Arabic letter is **built from colored toy bricks**, so kids
learn letter shapes (and how they change by position in a word) by *constructing* and
*tracing* them, then matching them to sounds, words, and pictures. Gamified like
Duolingo: hearts (lives), XP, energy, streaks, level map, progress bar made of LEGO studs.

MVP scope = pure concept demo. **No server, no auth backend, no payments.** All content
hardcoded in organized data files. Real recorded Arabic audio is bundled in assets.

## 2. Brand

- Name: **LET'S PLAY!** — Arabic: **يلا نلعب**
- Logo assets in `assets/images/logo/`:
  - `logo_blocks_blue.png` — multicolor block wordmark on royal-blue (app icon / splash)
  - `logo_yellow.png` — yellow block wordmark, transparent bg (large canvas, logo centered)
  - `logo_blue_on_yellow.png` — blue wordmark on yellow (large canvas, logo centered)
- Wordmark style: LEGO brick outline containing blocky "LET'S PLAY" letters.
- Tagline used on loading screen: "Finishing up your custom plan"

## 3. Color palette (sampled from XD prototypes)

| Token | Hex | Usage |
|---|---|---|
| royalBlue | `#1B2CFF` | login bg, blue exercise cards, brand |
| skyBlue | `#2CA9E1` | plan-loading screen bg |
| brandYellow | `#FFD800` | question cards, unlocked tiles, primary buttons, Level-1 header |
| orange | `#F7941D` | Level-2 header, bricks, tashkeel card |
| brickRed | `#EF4046` | bricks, hearts |
| legoGreen | `#43C330` | progress-bar studs, settings gear, success |
| purple | `#6B2CF5` | speech-exercise card, Level-4 accents |
| ink | `#111111` | borders, text, hard shadows |
| bgWhite | `#FFFFFF` | screen background |
| tileGray | `#F2F2F2` | locked tiles, disabled buttons, option tiles |
| borderGray | `#E0E0E0` | thin borders on gray tiles |
| textGray | `#9B9B9B` | secondary/disabled text |

## 4. Design language ("neo-brutalist toy")

- White backgrounds; generous whitespace; content centered.
- Cards & buttons: solid fill, **2.5–3 px black border, radius 10–12, hard offset
  shadow** (black, offset ~(0,4) to (4,6), **zero blur**).
- Gray "quiet" elements (option tiles, disabled CONTINUE) have *no* black border —
  1 px `borderGray` border, `tileGray` fill, `textGray` text, subtle radius.
- Buttons/headings: bold, uppercase for buttons (`CONTINUE`), wide letter-spacing (~1.5).
- Progress bar: white track w/ thin gray border; fill is a row of **green LEGO studs**
  (small circles) growing left→right.
- Hearts: red heart w/ black outline + count. Stats row: `✦ 13,500` (yellow sparkle),
  `❤ 6`, `⚡ 10`, green gear (settings).
- LEGO bricks (CustomPaint): rounded-rect body (r≈4), 2×2 or 2×4 studs (circles w/
  lighter top highlight), slightly darker bottom edge for depth. Brick colors:
  red/orange/green/blue/purple.
- Baseplate (build exercise bg): white with a grid of faint gray studs (outlined circles).
- Typography: rounded geometric sans, bold. Bundled font **Baloo Bhaijaan 2**
  (supports Arabic + Latin; weights 400–800). Arabic rendered big and bold.
- iPhone-frame-friendly; must look great in portrait on a phone.

## 5. Screens & flows (MVP)

### 5.1 Splash
Royal blue, centered `logo_blocks_blue`-style wordmark (use yellow logo on blue),
auto-advance ~1.5 s → Login.

### 5.2 Login (visual only)
Royal-blue bg. White bold `Login` heading + small white subtitle. Two inputs
(email, password): white/light fill, black 2 px border, lock/person icons, gray hints.
`Remember me` checkbox + yellow `Forgot your password?`. Black-bordered light `Sign in`
button (hard shadow) → advances. `Login with Facebook` button (visual only).
Bottom: `Don't have an account? Sign up` (yellow link) → also just advances.
Any action navigates to Onboarding. No validation.

### 5.3 Onboarding — "Tell us about yourself"
White bg, back chevron, title, **stud progress bar** for N steps.
Each step: big **yellow question card** (black border, hard shadow, bold black text)
+ vertical list of gray option tiles (tap → tile turns yellow w/ black border, then
advance after ~350 ms). Steps (hardcode in a content file):
1. "Which dialect of Arabic are you interested in?" — Levantine / Egyptian / Gulf / Modern standard arabic
2. "How old is the learner?" — Under 6 / 6–9 / 10–12 / Teen+
3. "How much Arabic do they know?" — Nothing yet / Some letters / Words & phrases / Can read a little
4. "What's your daily goal?" — 5 min / 10 min / 15 min / 20 min

### 5.4 Plan loading
Sky-blue bg. White rounded logo chip (white card, royal-blue "LET'S PLAY!" + Arabic
يلا نلعب underneath) at top-center. Bold white "Finishing up your custom plan".
Animated LEGO brick (yellow over blue 3D-ish block, gentle bounce) + subtle progress.
Auto-advance ~2.5 s → Home shell.

### 5.5 Home shell (bottom nav)
White bottom bar, thin top divider, 4 tabs: **Home (house), Quests (sparkle ✦),
Leaderboard (crown), Profile (smiley)**. Icons colorful w/ black outlines; active tab
highlighted. Only Home is fully functional; the other three are polished placeholder
screens ("coming soon" in brand style — still must look intentional, with brand cards).

### 5.6 Home
- Stats bar (top): ✦ 13,500 · ❤ 6 · ⚡ 10 · green gear.
- **Level 1 (Letters)** — yellow header card: title + "Learn all the letters and their
  usage in words and unlock new worlds." Below: 5-column grid of letter tiles
  (Arabic letter + Latin transliteration under it). First letters unlocked
  (yellow, tappable): أ (aa), ب (b), ت (t); rest locked (gray). Tapping أ or ب starts
  that letter's lesson. Tapping locked tile → playful shake / "finish previous letters" snack.
- **Level 2 (Tashkeel)** — orange header card: "Learn all the tashkeel and their
  positions either over or below the baseline" + a row of locked gray tashkeel tiles
  (ـَ ـِ ـُ ـً …) with one orange unlocked demo tile (opens Fatha info sheet: orange card
  `فتحه (FAT-HAH) Letter+a` + audio, staircase of 3 orange bricks above a green
  "Ascender" line — matches the prototype).
- **Level 3 (Words)**, **Level 4 (Sentences)**, **Level 5 (Conversations)** — blue /
  purple / green header cards with one-line descriptions and locked tile rows
  (keeps the scroll looking rich; all locked).

### 5.7 Lesson flow (the core demo) — letters أ and ب
Sequence per letter (a `LessonFlowScreen` hosting exercise pages):
Top bar: X (exit → confirm dialog), ❤ count, stud progress bar (fills per completed step).

Exercise types (each its own widget, driven by hardcoded lesson data):
1. **Letter intro** — big yellow card w/ the letter, name + transliteration below,
   audio button auto-plays letter sound; CONTINUE.
2. **Build the letter** — LEGO baseplate; ghost outlines (white cells w/ gray border)
   forming the letter; a tray of bricks below (colored, black-border style). Drag bricks
   onto outline slots (snap when close). Bottom bar: retry button, `⏱ n` countdown-ish
   timer, `⚡ n`, `Moves: n` (decrement per drag). When all slots filled → bricks pop
   (scale bounce) → auto-advance. Keep it forgiving (no fail state; timer is cosmetic).
3. **Trace the letter** — the letter rendered as colored bricks; a blue rounded
   stroke follows the user's finger along a predefined path (list of normalized points);
   progress by proximity — forgiving hit radius. Hint: animated white hand + blue dot.
   Bottom: retry, ⏱, ⚡. Complete → advance.
4. **Match the image** — "Match the image" heading; white card (soft shadow) with the
   word in Arabic + small audio icon button; 3 image option cards (white, thin gray
   border; BIG emoji as illustration). Correct → card flashes green border, CONTINUE
   enables (turns yellow). Wrong → red shake, lose 1 heart.
5. **Choose what you heard** — audio button (big) + snail slow-play button (plays same
   clip at 0.6× rate); 2×2 grid of image/letter option cards; same right/wrong behavior.
6. **Lesson complete** — celebration: brand-colored brick confetti, `+120 ✦` XP tally,
   `⚡ +10`, big yellow CONTINUE → back to Home with XP/hearts persisted in app state
   and the next letter unlocked.

Lesson content (hardcoded in `lib/data/content/`):
- **Alef lesson**: intro أ (`alef.mp3`); build أ; trace أ; match `أب` (father,
  `ab_father.mp3`) vs 🐰 🦁; hear `أسد` (`asad_lion.mp3`) → 🦁 vs 👨 🐰 and letter-card أ.
- **Baa lesson**: intro ب (`baa.mp3`); build ب; trace ب; match `بطة` (duck,
  `batta_duck.mp3`) vs 🚪 🐄; hear `باب` (`bab_door.mp3`) → 🚪 vs 🦆 🐄 ب.

Emoji illustration map (until real art is licensed): father&son 👨, rabbit 🐰, lion 🦁,
duck 🦆, door 🚪, cow 🐄. Render emoji at ~64–80 px inside white option cards.

### 5.8 Audio
`assets/audio/` (bundled, real recordings — filenames already ASCII):
`alef.mp3, ab_father.mp3, arnab_rabbit.mp3, asad_lion.mp3, baa.mp3, batta_duck.mp3,
bab_door.mp3, baqara_cow.mp3, fatha.mp3`. Use `audioplayers` package; simple
`AudioService` wrapper (play asset, optional playbackRate for snail button).

## 6. Architecture (clean, but demo-sized)

```
lib/
  main.dart                     # bootstrap
  app.dart                      # MaterialApp, theme, routes
  core/
    theme/                      # lp_colors.dart, lp_text_styles.dart, lp_theme.dart
    widgets/                    # LpButton, LpCard, OptionTile, StudProgressBar,
                                # StatsBar, BrickWidget/BrickPainter, BaseplateBackground,
                                # AudioButton, HeartCounter, ExerciseTopBar, ExerciseBottomBar
    services/audio_service.dart
  data/
    models/                     # Letter, LevelSection, Lesson, Exercise (sealed variants),
                                # OnboardingQuestion, UserProgress
    content/                    # letters_content.dart, levels_content.dart,
                                # lesson_alef.dart, lesson_baa.dart, onboarding_content.dart
  state/
    app_state.dart              # ChangeNotifier: xp, hearts, energy, unlocked letters,
                                # onboarding answers; provided via provider
  features/
    splash/  auth/  onboarding/  home/  lesson/  (screen + feature widgets each)
```

- State: `provider` + `ChangeNotifier` (no server ⇒ no repositories/BLoC needed;
  keep models immutable, content files const).
- Navigation: plain named routes or `Navigator.push` — no deep-link needs.
- All strings that are content live in `data/content/`, not inline in widgets.
- Font bundled under `assets/fonts/` and declared in pubspec (family: `BalooBhaijaan2`).
- Must pass `flutter analyze` clean; format with `dart format`.
