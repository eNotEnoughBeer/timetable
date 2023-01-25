import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/bells_get_all_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late GetBellsUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetBellsUsecase(mockRepository);
  });

  const tResultEntities = [
    SchoolBellEntity(uid: '', fromTime: '', toTime: '', lessonNumber: 1),
    SchoolBellEntity(uid: '', fromTime: '', toTime: '', lessonNumber: 2),
    SchoolBellEntity(uid: '', fromTime: '', toTime: '', lessonNumber: 3),
  ];

  test('''GetBellsUsecase should launch an corresponding function of a repo,
  and return a list of three SchoolBellEntity ''', () async {
    //arrange
    when(() => mockRepository.getBells())
        .thenAnswer((_) async => const Right(tResultEntities));
    //act
    final result = await usecase();
    var resultLength = 0;
    result.fold((l) => null, (r) => resultLength = r.length);
    //assert
    expect(result, const Right(tResultEntities));
    expect(resultLength, 3);
    verify(() => mockRepository.getBells());
    verifyNoMoreInteractions(mockRepository);
  });
}
