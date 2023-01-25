import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class UpdateUserDataUsecase {
  final Repository personRepository;
  UpdateUserDataUsecase(this.personRepository);

  Future<Either<Failure, void>> call(
      PersonEntity userData, String password) async {
    return await personRepository.saveUserData(userData, password);
  }
}
