import '../models/lesson.dart';
import 'lesson_alef.dart';
import 'lesson_baa.dart';

/// All authored lessons, by id.
const Map<String, Lesson> lessonsById = <String, Lesson>{
  'lesson_alef': lessonAlef,
  'lesson_baa': lessonBaa,
};

Lesson? lessonById(String? id) => id == null ? null : lessonsById[id];
