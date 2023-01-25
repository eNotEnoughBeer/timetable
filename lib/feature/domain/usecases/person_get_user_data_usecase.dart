import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class GetUserDataUsecase {
  final Repository personRepository;
  GetUserDataUsecase(this.personRepository);

  Future<Either<Failure, PersonEntity>> call() async {
    return await personRepository.getUserData();
  }
}
