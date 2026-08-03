import '../../core/theme/lp_colors.dart';
import '../models/letter.dart';
import '../models/level_section.dart';

/// The five level bands of the home screen, per the 2026-07 design drop:
/// 1 Letters (yellow) · 2 Tashkeel (orange) · 3 Numbers (blue) ·
/// 4 Words (green) · 5 Sentences (purple).
const List<LevelSection> levelsContent = <LevelSection>[
  LevelSection(
    id: 'letters',
    number: 1,
    title: 'Level 1 (Letters)',
    description:
        'Learn all the letters and their usage in words and unlock new worlds.',
    color: LpColors.brandYellow,
  ),
  LevelSection(
    id: 'tashkeel',
    number: 2,
    title: 'Level 2 (Tashkeel)',
    description:
        'Learn all the tashkeel and their positions either over or below the baseline',
    color: LpColors.levelOrange,
    lightForeground: true,
  ),
  LevelSection(
    id: 'numbers',
    number: 3,
    title: 'Level 3 (Numbers)',
    description: 'Learn all the numbers and their usage and unlock new worlds.',
    color: LpColors.levelBlue,
    lightForeground: true,
  ),
  LevelSection(
    id: 'words',
    number: 4,
    title: 'Level 4 (Words)',
    description: 'Learn all the words and their usage and unlock new worlds.',
    color: LpColors.levelGreen,
    lightForeground: true,
    categories: <LevelCategory>[
      LevelCategory(
        id: 'words2',
        arabic: 'في',
        english: '2 letter words',
        lessonId: 'lesson_word_types',
      ),
      LevelCategory(id: 'words3', arabic: 'رجل', english: '3 letter words'),
      LevelCategory(id: 'words4', arabic: 'جماد', english: '4 letter words'),
      LevelCategory(id: 'words5', arabic: 'حيوان', english: '5 letter words'),
    ],
  ),
  LevelSection(
    id: 'sentences',
    number: 5,
    title: 'Level 5 (Sentences)',
    description: 'Learn all the phrases and their usage and unlock new worlds.',
    color: LpColors.levelPurple,
    lightForeground: true,
    categories: <LevelCategory>[
      LevelCategory(
        id: 'intro_yourself',
        arabic: 'عرف نفسك',
        english: 'Introduce Yourself',
        lessonId: 'lesson_greetings',
      ),
      LevelCategory(id: 'directions', arabic: 'الاتجاهات', english: 'Directions'),
      LevelCategory(id: 'travel', arabic: 'السفر', english: 'Travel'),
      LevelCategory(id: 'restaurants', arabic: 'مطاعم', english: 'Restaurants'),
    ],
  ),
];

/// Extra Level-1 tiles after the 28 base letters (combined forms + hamza
/// variants, bottom rows of the design's alphabet grid).
const List<Letter> lettersExtraContent = <Letter>[
  Letter(id: 'lam_meem', glyph: 'لما', translit: 'l+m'),
  Letter(id: 'laa', glyph: 'لا', translit: 'Laa'),
  Letter(id: 'hamza', glyph: 'ء', translit: '2'),
  Letter(id: 'hamza_alef', glyph: 'أ', translit: '2'),
  Letter(id: 'hamza_below', glyph: 'إ', translit: '2'),
  Letter(id: 'hamza_waw', glyph: 'ؤ', translit: '2'),
  Letter(id: 'hamza_yaa', glyph: 'ئ', translit: '2'),
];

/// Tashkeel tile row of Level 2. Only fatha is unlocked — it opens the full
/// fatha lesson. Reuses [Letter] as a generic glyph tile.
const List<Letter> tashkeelContent = <Letter>[
  Letter(id: 'fatha', glyph: 'ـَ', translit: 'a', lessonId: 'lesson_fatha'),
  Letter(id: 'kasra', glyph: 'ـِ', translit: 'i'),
  Letter(id: 'damma', glyph: 'ـُ', translit: 'u'),
  Letter(id: 'sukoon', glyph: 'ـْ', translit: '—'),
  Letter(id: 'shadda', glyph: 'ـّ', translit: 'xx'),
  Letter(id: 'tanween_fath', glyph: 'ـً', translit: 'an'),
  Letter(id: 'tanween_kasr', glyph: 'ـٍ', translit: 'in'),
  Letter(id: 'tanween_damm', glyph: 'ـٌ', translit: 'un'),
];

const Set<String> defaultUnlockedTashkeelIds = <String>{'fatha'};

/// Level-3 number tiles: ١–١٠ then the hundreds up to ١٠٠٠. Only ٢ is
/// unlocked (the design's Level-3 lesson teaches ithnan).
const List<Letter> numbersContent = <Letter>[
  Letter(id: 'n1', glyph: '١', translit: '1'),
  Letter(id: 'n2', glyph: '٢', translit: '2', lessonId: 'lesson_ithnan'),
  Letter(id: 'n3', glyph: '٣', translit: '3'),
  Letter(id: 'n4', glyph: '٤', translit: '4'),
  Letter(id: 'n5', glyph: '٥', translit: '5'),
  Letter(id: 'n6', glyph: '٦', translit: '6'),
  Letter(id: 'n7', glyph: '٧', translit: '7'),
  Letter(id: 'n8', glyph: '٨', translit: '8'),
  Letter(id: 'n9', glyph: '٩', translit: '9'),
  Letter(id: 'n10', glyph: '١٠', translit: '10'),
  Letter(id: 'n100', glyph: '١٠٠', translit: '100'),
  Letter(id: 'n200', glyph: '٢٠٠', translit: '200'),
  Letter(id: 'n300', glyph: '٣٠٠', translit: '300'),
  Letter(id: 'n400', glyph: '٤٠٠', translit: '400'),
  Letter(id: 'n500', glyph: '٥٠٠', translit: '500'),
  Letter(id: 'n600', glyph: '٦٠٠', translit: '600'),
  Letter(id: 'n700', glyph: '٧٠٠', translit: '700'),
  Letter(id: 'n800', glyph: '٨٠٠', translit: '800'),
  Letter(id: 'n900', glyph: '٩٠٠', translit: '900'),
  Letter(id: 'n1000', glyph: '١٠٠٠', translit: '1000'),
];

const Set<String> defaultUnlockedNumberIds = <String>{'n2'};

/// First category of Levels 4/5 is playable from the start.
const Set<String> defaultUnlockedCategoryIds = <String>{
  'words2',
  'intro_yourself',
};
