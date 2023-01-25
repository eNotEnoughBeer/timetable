import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class LogoutUsecase {
  final Repository personRepository;
  LogoutUsecase(this.personRepository);

  Future<Either<Failure, void>> call() async {
    return await personRepository.logout();
  }
}
