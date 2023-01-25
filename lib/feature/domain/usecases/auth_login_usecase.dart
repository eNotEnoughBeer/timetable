import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class LoginUsecase {
  final Repository personRepository;
  LoginUsecase(this.personRepository);

  Future<Either<Failure, PersonEntity>> call(
      String email, String password) async {
    return await personRepository.login(email, password);
  }
}
