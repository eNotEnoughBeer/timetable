import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/peron_get_user_cached_password.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late GetUserCachedPasswordUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetUserCachedPasswordUsecase(mockRepository);
  });
  const tFakeCachedPassword = '123456';

  test(
      '''GetUserCachedPasswordUsecase should launch an corresponding function of a repo,
  and return string ''', () async {
    //arrange
    when(() => mockRepository.getUserCachedPassword())
        .thenReturn(tFakeCachedPassword);
    //act
    final result = usecase();
    //assert
    expect(result, tFakeCachedPassword);
    verify(() => mockRepository.getUserCachedPassword());
    verifyNoMoreInteractions(mockRepository);
  });
}
