import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/auth_is_logged_in_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late IsLoggedInUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = IsLoggedInUsecase(mockRepository);
  });

  test('''IsLoggedInUsecase should launch an corresponding function of a repo,
  and return true ''', () async {
    //arrange
    when(() => mockRepository.isUserLoggedIn()).thenReturn(true);
    //act
    final result = usecase();
    //assert
    expect(result, true);
    verify(() => mockRepository.isUserLoggedIn());
    verifyNoMoreInteractions(mockRepository);
  });
}
