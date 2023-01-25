import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class SignUpUsecase {
  final Repository personRepository;
  SignUpUsecase(this.personRepository);

  Future<Either<Failure, PersonEntity>> call(
      String email, String password, String userName) async {
    return await personRepository.createUser(email, password, userName);
  }
}
