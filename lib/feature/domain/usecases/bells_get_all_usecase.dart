import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class GetBellsUsecase {
  final Repository personRepository;
  GetBellsUsecase(this.personRepository);

  Future<Either<Failure, List<SchoolBellEntity>>> call() async {
    return await personRepository.getBells();
  }
}
