import '../../core/theme/lp_colors.dart';
import '../models/letter.dart';
import '../models/level_section.dart';

/// The five level bands of the home screen (spec 5.6).
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
    color: LpColors.orange,
  ),
  LevelSection(
    id: 'words',
    number: 3,
    title: 'Level 3 (Words)',
    description: 'Snap letters together to build your first real words.',
    color: LpColors.royalBlue,
    lightForeground: true,
  ),
  LevelSection(
    id: 'sentences',
    number: 4,
    title: 'Level 4 (Sentences)',
    description: 'Combine words into full sentences and start reading.',
    color: LpColors.purple,
    lightForeground: true,
  ),
  LevelSection(
    id: 'conversations',
    number: 5,
    title: 'Level 5 (Conversations)',
    description: 'Practice real conversations and bring it all to life.',
    color: LpColors.legoGreen,
    lightForeground: true,
  ),
];

/// Tashkeel tile row of Level 2. Only fatha is unlocked (demo tile that
/// opens the Fatha info screen). Reuses [Letter] as a generic glyph tile.
const List<Letter> tashkeelContent = <Letter>[
  Letter(id: 'fatha', glyph: 'ـَ', translit: 'a', lessonId: 'fatha_info'),
  Letter(id: 'kasra', glyph: 'ـِ', translit: 'i'),
  Letter(id: 'damma', glyph: 'ـُ', translit: 'u'),
  Letter(id: 'sukoon', glyph: 'ـْ', translit: '—'),
  Letter(id: 'shadda', glyph: 'ـّ', translit: 'xx'),
  Letter(id: 'tanween_fath', glyph: 'ـً', translit: 'an'),
  Letter(id: 'tanween_kasr', glyph: 'ـٍ', translit: 'in'),
  Letter(id: 'tanween_damm', glyph: 'ـٌ', translit: 'un'),
];

const Set<String> defaultUnlockedTashkeelIds = <String>{'fatha'};

/// Fatha info screen content (matches the fat7a prototype frame).
const String fathaTitleArabic = 'فتحه';
const String fathaTitleLatin = '(FAT-HAH)';
const String fathaFormula = 'Letter+a';
const String fathaAudioFile = 'fatha.mp3';
const String fathaAscenderLabel = 'Ascender';
