import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/lesson_get_all_usecase.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late GetLessonsUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetLessonsUsecase(mockRepository);
  });

  const tResultEntities = [
    LessonEntity(
      uid: '',
      name: '',
      description: '',
      googleKey: '',
      iconIndex: 1,
      teacherAvatar: '',
      teacherName: '',
    ),
    LessonEntity(
      uid: '',
      name: '',
      description: '',
      googleKey: '',
      iconIndex: 2,
      teacherAvatar: '',
      teacherName: '',
    ),
  ];

  test('''GetLessonsUsecase should launch an corresponding function of a repo,
  and return a list of two LessonEntity ''', () async {
    //arrange
    when(() => mockRepository.getLessons())
        .thenAnswer((_) async => const Right(tResultEntities));
    //act
    final result = await usecase();
    var resultLength = 0;
    result.fold((l) => null, (r) => resultLength = r.length);
    //assert
    expect(result, const Right(tResultEntities));
    expect(resultLength, 2);
    verify(() => mockRepository.getLessons());
    verifyNoMoreInteractions(mockRepository);
  });
}
