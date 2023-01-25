import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/auth_signup_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late SignUpUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = SignUpUsecase(mockRepository);
  });

  const tEmail = 'test@test.com';
  const tPassword = '12345678';
  const tUserName = 'test';
  const tResultEntity = PersonEntity(
    avatar: '',
    name: tUserName,
    uid: '',
    email: tEmail,
    role: 'student',
  );

  test('''SignUpUsecase should launch a createUser function of a repo,
  and that function must use an usecase email, password, username ''',
      () async {
    //arrange
    when(() => mockRepository.createUser(any(), any(), any()))
        .thenAnswer((_) async => const Right(tResultEntity));
    //act
    final result = await usecase(tEmail, tPassword, tUserName);
    //assert
    expect(result, const Right(tResultEntity));
    verify(() => mockRepository.createUser(tEmail, tPassword, tUserName));
    verifyNoMoreInteractions(mockRepository);
  });
}
