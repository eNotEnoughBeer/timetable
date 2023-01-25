import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/bells_delete_usecase.dart';

class MockRepository extends Mock implements Repository {}

class MockSchoolBellEntity extends Fake implements SchoolBellEntity {}

void main() {
  late DeleteBellUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = DeleteBellUsecase(mockRepository);
    registerFallbackValue(MockSchoolBellEntity());
  });

  const tResultEntity = SchoolBellEntity(
    uid: '',
    fromTime: '',
    toTime: '',
    lessonNumber: 1,
  );

  test('''DeleteBellUsecase should launch an corresponding function of a repo,
  and return void ''', () async {
    //arrange
    when(() => mockRepository.deleteBell(any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tResultEntity);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.deleteBell(tResultEntity));
    verifyNoMoreInteractions(mockRepository);
  });
}
