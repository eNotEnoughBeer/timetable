import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class UpdateLessonUsecase {
  final Repository personRepository;
  UpdateLessonUsecase(this.personRepository);

  Future<Either<Failure, void>> call(LessonEntity data) async {
    return await personRepository.updateLesson(data);
  }
}
