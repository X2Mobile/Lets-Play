import '../../core/theme/lp_colors.dart';
import '../models/exercise.dart';
import '../models/lesson.dart';

/// Level 4 · Lesson 1 — word types (design `LEVEL 4/0–26`): teach-then-drill
/// through اسم / فعل / حرف, noun types and signs, verb tenses and the past /
/// imperative conjugation battery. Teach cards are royal blue per the
/// design; a few design typos are fixed (جماد, the verb-row glosses).
const Lesson lessonWordTypes = Lesson(
  id: 'lesson_word_types',
  titleArabic: 'انواع الكلمات',
  titleLatin: 'Word Types',
  levelNumber: 4,
  lessonNumber: 1,
  levelColor: LpColors.levelGreen,
  introChecklist: <String>[
    'Forming words',
    'Writing words',
    'Pronunciation',
    'Dialogue',
  ],
  introCharacterAsset: 'characters/intro_l4.png',
  countdownCharacterAsset: 'characters/countdown_l4.png',
  pointsReward: 6000,
  accuracyLabel: '82%',
  speedLabel: '1:50',
  exercises: <Exercise>[
    // Word types: noun / verb / particle (design 2-01).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'انواع الكلمات',
      titleLatin: '(Word Types)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(
          arabic: 'اسم = رجل',
          gloss: '(Noun) = (Man)',
          audioFile: 'rajul_man.mp3',
        ),
        TeachItem(arabic: 'فعل = يسبح', gloss: '(Verb) = (Swims)'),
        TeachItem(arabic: 'حرف = في', gloss: '(Particle) = (In)'),
      ],
    ),
    // Tap all the nouns in the six-word grid (design 3).
    MultiSelectExercise(
      heading: 'Choose the Name\nin these words',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'محفظة', label: 'Wallet', isCorrect: true),
        ExerciseOption(letter: 'البيت', label: 'House', isCorrect: true),
        ExerciseOption(letter: 'طائرة', label: 'Plane', isCorrect: true),
        ExerciseOption(letter: 'نسافر', label: 'Travel', isCorrect: false),
        ExerciseOption(letter: 'و', label: 'And', isCorrect: false),
        ExerciseOption(letter: 'تطبخ', label: 'Cook', isCorrect: false),
      ],
      columns: 2,
    ),
    // Noun types (design 4-01; جماد fixed from the design's حماد).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'انواع الاسم',
      titleLatin: '(Noun Types)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(arabic: 'إنسان', gloss: '(Human)'),
        TeachItem(arabic: 'حيوان', gloss: '(Animal)'),
        TeachItem(arabic: 'جماد', gloss: '(Object)'),
        TeachItem(arabic: 'مكان', gloss: '(Place)'),
        TeachItem(arabic: 'نبات', gloss: '(Plant)'),
        TeachItem(arabic: 'صفة', gloss: '(Characteristic)'),
      ],
    ),
    // Choose the noun among four words (design 5).
    ChoiceExercise(
      heading: 'Choose the Noun',
      options: <ExerciseOption>[
        ExerciseOption(letter: 'قرأ', isCorrect: false),
        ExerciseOption(letter: 'كاتب', isCorrect: true),
        ExerciseOption(letter: 'قارئ', isCorrect: false),
        ExerciseOption(letter: 'لاعب', isCorrect: false),
      ],
      columns: 2,
    ),
    // باب → picture (design 6).
    ChoiceExercise(
      heading: 'Choose the correct answer',
      prompt: ChoicePrompt(
        arabic: 'باب',
        cardColor: LpColors.royalBlue,
        audioFile: 'bab_door.mp3',
      ),
      options: <ExerciseOption>[
        ExerciseOption(
          imageAsset: 'illustrations/door.png',
          label: 'Door',
          isCorrect: true,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/house.png',
          label: 'House',
          isCorrect: false,
        ),
      ],
      columns: 2,
    ),
    // الكرسي → transliteration (design 7).
    ChoiceExercise(
      heading: 'Choose the correct answer',
      prompt: ChoicePrompt(
        arabic: 'الكرسي',
        cardColor: LpColors.royalBlue,
        audioFile: 'kursi_chair.mp3',
      ),
      options: <ExerciseOption>[
        ExerciseOption(label: 'El korsi', isCorrect: true),
        ExerciseOption(label: 'Baab', isCorrect: false),
        ExerciseOption(label: 'Beet', isCorrect: false),
      ],
    ),
    // بيت → picture (design 8).
    ChoiceExercise(
      heading: 'Choose the correct answer',
      prompt: ChoicePrompt(
        arabic: 'بيت',
        cardColor: LpColors.royalBlue,
        audioFile: 'bayt_house.mp3',
      ),
      options: <ExerciseOption>[
        ExerciseOption(
          imageAsset: 'illustrations/house.png',
          label: 'House',
          isCorrect: true,
        ),
        ExerciseOption(
          imageAsset: 'illustrations/door.png',
          label: 'Door',
          isCorrect: false,
        ),
      ],
      columns: 2,
    ),
    // Noun signs (design 9-01).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'علامات تميز الاسم',
      titleLatin: '(Noun Signs)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(arabic: 'ــً ــٍ ــٌ', gloss: 'Tanween'),
        TeachItem(arabic: 'ة', gloss: 'Taa marbuta'),
        TeachItem(arabic: 'الـ', gloss: 'Al- prefix'),
      ],
    ),
    // يعمل is a verb → False (design 11).
    ChoiceExercise(
      heading: 'This word is a Noun',
      prompt: ChoicePrompt(arabic: 'يعمل', cardColor: LpColors.crimson),
      options: <ExerciseOption>[
        ExerciseOption(label: 'True', isCorrect: false),
        ExerciseOption(label: 'False', isCorrect: true),
      ],
      columns: 2,
    ),
    // Verb types (design 12-01).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'انواع الفعل',
      titleLatin: '(Verb Types)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(arabic: 'الفعل الماضى = خرج', gloss: '(Past Tense) = (Went out)'),
        TeachItem(
          arabic: 'الفعل المضارع = يخرج',
          gloss: '(Present Tense) = (Goes out)',
        ),
        TeachItem(
          arabic: 'الفعل الأمر = اخرج',
          gloss: '(Imperative mood) = (Go out)',
        ),
      ],
    ),
    // Imperative mood (design 13-01).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'الفعل الأمر',
      titleLatin: '(Imperative Mood)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(arabic: 'مذكر = انظر', gloss: '(Masculine) = (Look)'),
        TeachItem(arabic: 'مؤنث = انظري', gloss: '(Feminine) = (Look)'),
      ],
    ),
    // Verb fill-the-blank battery (design 14-01 → 21).
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'أمي .... الطعام',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'طبخت', isCorrect: true),
        ExerciseOption(letter: 'طبخ', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'أنا .... لابني',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'ذاكرتُ', isCorrect: true),
        ExerciseOption(letter: 'ذاكرتْ', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'أخي .... بالأمس',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'سافر', isCorrect: true),
        ExerciseOption(letter: 'سافرنا', isCorrect: false),
      ],
      columns: 2,
    ),
    // Past-tense verb signs (design 17-01).
    TeachCardExercise(
      heading: 'Learn',
      titleArabic: 'علامات الفعل الماضي',
      titleLatin: '(Past Tense Verb Signs)',
      cardColor: LpColors.royalBlue,
      items: <TeachItem>[
        TeachItem(arabic: 'تُ = أنا خرجتُ', gloss: '(I went out)'),
        TeachItem(arabic: 'نا = نحن خرجنا', gloss: '(We went out)'),
        TeachItem(arabic: 'تْ = هي خرجتْ', gloss: '(She went out)'),
      ],
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'نحن .... سيارة',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'نحتاج', isCorrect: true),
        ExerciseOption(letter: 'أحتاج', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'أنا .... عن عمل',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'أبحث', isCorrect: true),
        ExerciseOption(letter: 'يبحث', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'هي .... الإنجليزية',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'تتحدث', isCorrect: true),
        ExerciseOption(letter: 'نتحدث', isCorrect: false),
      ],
      columns: 2,
    ),
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(
        arabic: 'هو .... كرة السلة',
        cardColor: LpColors.royalBlue,
      ),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'يلعب', isCorrect: true),
        ExerciseOption(letter: 'ألعب', isCorrect: false),
      ],
      columns: 2,
    ),
    // Imperative true/false (design 24).
    ChoiceExercise(
      heading: 'Imperative Mood',
      prompt: ChoicePrompt(
        arabic: 'اكتب الرسالة',
        latin: 'Write the message',
        cardColor: LpColors.crimson,
      ),
      options: <ExerciseOption>[
        ExerciseOption(label: 'True', isCorrect: true),
        ExerciseOption(label: 'False', isCorrect: false),
      ],
      columns: 2,
    ),
    // Classify أكل (design 25).
    ChoiceExercise(
      heading: 'Choose the correct verb',
      prompt: ChoicePrompt(arabic: 'أكل', cardColor: LpColors.royalBlue),
      options: <ExerciseOption>[
        ExerciseOption(letter: 'مضارع', isCorrect: false),
        ExerciseOption(letter: 'ماض', isCorrect: true),
        ExerciseOption(letter: 'أمر', isCorrect: false),
      ],
    ),
  ],
);
