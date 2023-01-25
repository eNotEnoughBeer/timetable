import 'package:timetable/feature/domain/repositories/repository.dart';

class IsLoggedInUsecase {
  final Repository personRepository;
  IsLoggedInUsecase(this.personRepository);

  bool call() => personRepository.isUserLoggedIn();
}
