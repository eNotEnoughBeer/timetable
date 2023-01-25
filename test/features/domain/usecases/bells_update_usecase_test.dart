import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/bells_update_usecase.dart';

class MockRepository extends Mock implements Repository {}

class MockSchoolBellEntity extends Fake implements SchoolBellEntity {}

void main() {
  late UpdateBellUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = UpdateBellUsecase(mockRepository);
    registerFallbackValue(MockSchoolBellEntity());
  });

  const tResultEntity = SchoolBellEntity(
    uid: '',
    fromTime: '',
    toTime: '',
    lessonNumber: 1,
  );

  test('''UpdateBellUsecase should launch an corresponding function of a repo,
  and return void ''', () async {
    //arrange
    when(() => mockRepository.updateBell(any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tResultEntity);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.updateBell(tResultEntity));
    verifyNoMoreInteractions(mockRepository);
  });
}
