import 'package:timetable/feature/domain/repositories/repository.dart';

class GetUserUidUsecase {
  final Repository personRepository;
  GetUserUidUsecase(this.personRepository);

  String call() {
    return personRepository.getUserUid();
  }
}
