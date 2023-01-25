import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/person_update_user_data_usecase.dart';

class MockRepository extends Mock implements Repository {}

class MockPersonEntity extends Fake implements PersonEntity {}

void main() {
  late UpdateUserDataUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = UpdateUserDataUsecase(mockRepository);
    registerFallbackValue(MockPersonEntity());
  });

  const tPassword = '123456';
  const tResultEntity = PersonEntity(
    avatar: '',
    name: '',
    uid: '',
    email: '',
    role: '',
  );

  test('''UpdateUserDataUsecase should launch a saveUserData function of a repo,
  and return void. saveUserData must use usecase input data ''', () async {
    //arrange
    when(() => mockRepository.saveUserData(any(), any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tResultEntity, tPassword);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.saveUserData(tResultEntity, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}
