import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_data_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late GetUserDataUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetUserDataUsecase(mockRepository);
  });

  const tResultEntity = PersonEntity(
    avatar: '',
    name: '',
    uid: '',
    email: '',
    role: '',
  );

  test('''GetUserDataUsecase should launch an corresponding function of a repo,
  and return a PersonEntity ''', () async {
    //arrange
    when(() => mockRepository.getUserData())
        .thenAnswer((_) async => const Right(tResultEntity));
    //act
    final result = await usecase();
    //assert
    expect(result, const Right(tResultEntity));
    verify(() => mockRepository.getUserData());
    verifyNoMoreInteractions(mockRepository);
  });
}
