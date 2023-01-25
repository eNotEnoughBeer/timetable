import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_uid.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late GetUserUidUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetUserUidUsecase(mockRepository);
  });
  const tResult = '123456';

  test('''GetUserUidUsecase should launch an corresponding function of a repo,
  and return string ''', () async {
    //arrange
    when(() => mockRepository.getUserUid()).thenReturn(tResult);
    //act
    final result = usecase();
    //assert
    expect(result, tResult);
    verify(() => mockRepository.getUserUid());
    verifyNoMoreInteractions(mockRepository);
  });
}
