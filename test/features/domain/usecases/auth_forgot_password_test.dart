import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/auth_forgot_password.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late ForgotPasswordUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = ForgotPasswordUsecase(mockRepository);
  });

  const tEmail = 'test@test.com';
  test('''forgotPassword usecase should launch 
      an corresponding function of a repo''', () async {
    //arrange
    when(() => mockRepository.forgotPassword(any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tEmail);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.forgotPassword(tEmail));
    verifyNoMoreInteractions(mockRepository);
  });
}
