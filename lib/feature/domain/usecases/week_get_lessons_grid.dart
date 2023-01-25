import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/lesson_grid_entity.dart';
import '../repositories/repository.dart';

class WeekGridLessonsGet {
  final Repository personRepository;
  WeekGridLessonsGet(this.personRepository);
// key = 5B
  Future<Either<Failure, List<List<LessonGridEntity>>>> call(String key) async {
    return await personRepository.getLessonsWeekGrid(key);
  }
}
