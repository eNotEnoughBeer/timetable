import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class ForgotPasswordUsecase {
  final Repository personRepository;
  ForgotPasswordUsecase(this.personRepository);

  Future<Either<Failure, void>> call(String email) async {
    return await personRepository.forgotPassword(email);
  }
}
