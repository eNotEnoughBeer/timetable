import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/auth_logout_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late LogoutUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = LogoutUsecase(mockRepository);
  });

  test('LogoutUsecase should launch an corresponding function of a repo',
      () async {
    //arrange
    when(() => mockRepository.logout())
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase();
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.logout());
    verifyNoMoreInteractions(mockRepository);
  });
}
