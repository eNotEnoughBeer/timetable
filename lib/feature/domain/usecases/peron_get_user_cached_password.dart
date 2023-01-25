import 'package:timetable/feature/domain/repositories/repository.dart';

class GetUserCachedPasswordUsecase {
  final Repository personRepository;
  GetUserCachedPasswordUsecase(this.personRepository);

  String call() {
    return personRepository.getUserCachedPassword();
  }
}
