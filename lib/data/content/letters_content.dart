import '../models/letter.dart';

/// The full alphabet grid of Level 1, in Arabic order (rendered RTL, 5 per
/// row, so أ sits top-right like the prototype).
const List<Letter> lettersContent = <Letter>[
  Letter(id: 'alef', glyph: 'أ', translit: 'aa', lessonId: 'lesson_alef'),
  Letter(id: 'baa', glyph: 'ب', translit: 'b', lessonId: 'lesson_baa'),
  Letter(id: 'taa', glyph: 'ت', translit: 't'),
  Letter(id: 'thaa', glyph: 'ث', translit: 'th'),
  Letter(id: 'jeem', glyph: 'ج', translit: 'j'),
  Letter(id: 'haa', glyph: 'ح', translit: 'h'),
  Letter(id: 'khaa', glyph: 'خ', translit: 'kh'),
  Letter(id: 'daal', glyph: 'د', translit: 'd'),
  Letter(id: 'dhaal', glyph: 'ذ', translit: 'dh'),
  Letter(id: 'raa', glyph: 'ر', translit: 'r'),
  Letter(id: 'zay', glyph: 'ز', translit: 'z'),
  Letter(id: 'seen', glyph: 'س', translit: 's'),
  Letter(id: 'sheen', glyph: 'ش', translit: 'sh'),
  Letter(id: 'saad', glyph: 'ص', translit: 'S'),
  Letter(id: 'daad', glyph: 'ض', translit: 'D'),
  // ط (emphatic T)
  Letter(id: 'ttaa', glyph: 'ط', translit: 'T'),
  // ظ (emphatic DH)
  Letter(id: 'dhaa', glyph: 'ظ', translit: 'DH'),
  Letter(id: 'ayn', glyph: 'ع', translit: '3'),
  Letter(id: 'ghayn', glyph: 'غ', translit: 'gh'),
  Letter(id: 'faa', glyph: 'ف', translit: 'f'),
  Letter(id: 'qaaf', glyph: 'ق', translit: 'q'),
  Letter(id: 'kaaf', glyph: 'ك', translit: 'k'),
  Letter(id: 'laam', glyph: 'ل', translit: 'L'),
  Letter(id: 'meem', glyph: 'م', translit: 'm'),
  Letter(id: 'noon', glyph: 'ن', translit: 'n'),
  // ه (light h — distinct from ح 'haa')
  Letter(id: 'ha', glyph: 'ه', translit: 'h'),
  Letter(id: 'waw', glyph: 'و', translit: 'w'),
  Letter(id: 'yaa', glyph: 'ي', translit: 'y'),
];

/// Letters available from the first launch.
const Set<String> defaultUnlockedLetterIds = <String>{'alef', 'baa', 'taa'};
