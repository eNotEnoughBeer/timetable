import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

class AddBellUsecase {
  final Repository personRepository;
  AddBellUsecase(this.personRepository);

  Future<Either<Failure, void>> call(SchoolBellEntity data) async {
    return await personRepository.addBell(data);
  }
}
