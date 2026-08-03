import '../models/lesson.dart';
import 'lesson_alef.dart';
import 'lesson_baa.dart';
import 'lesson_fatha.dart';
import 'lesson_greetings.dart';
import 'lesson_ithnan.dart';
import 'lesson_word_types.dart';

/// All authored lessons, by id — one per level band plus the two Level-1
/// letter lessons.
const Map<String, Lesson> lessonsById = <String, Lesson>{
  'lesson_alef': lessonAlef,
  'lesson_baa': lessonBaa,
  'lesson_fatha': lessonFatha,
  'lesson_ithnan': lessonIthnan,
  'lesson_word_types': lessonWordTypes,
  'lesson_greetings': lessonGreetings,
};

Lesson? lessonById(String? id) => id == null ? null : lessonsById[id];
