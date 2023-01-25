import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/auth_login_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late LoginUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = LoginUsecase(mockRepository);
  });

  const tEmail = 'test@test.com';
  const tPassword = '12345678';
  const tResultEntity = PersonEntity(
    avatar: '',
    name: 'test',
    uid: '',
    email: tEmail,
    role: 'student',
  );

  test('''LoginUsecase should launch an corresponding function of a repo,
  and that function must use an usecase\'s email and password ''', () async {
    //arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => const Right(tResultEntity));
    //act
    final result = await usecase(tEmail, tPassword);
    //assert
    expect(result, const Right(tResultEntity));
    verify(() => mockRepository.login(tEmail, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}
