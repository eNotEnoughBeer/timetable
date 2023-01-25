import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/lesson_grid_entity.dart';
import '../repositories/repository.dart';

class WeekGridLessonsSet {
  final Repository personRepository;
  WeekGridLessonsSet(this.personRepository);
// key = 5B
  Future<Either<Failure, void>> call(
      String key, List<List<LessonGridEntity>> data) async {
    return await personRepository.setLessonsWeekGrid(key, data);
  }
}
