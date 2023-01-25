import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/lesson_update_usecase.dart';

class MockRepository extends Mock implements Repository {}

class MockLessonEntity extends Fake implements LessonEntity {}

void main() {
  late UpdateLessonUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = UpdateLessonUsecase(mockRepository);
    registerFallbackValue(MockLessonEntity());
  });

  const tResultEntity = LessonEntity(
    uid: '',
    name: '',
    description: '',
    googleKey: '',
    iconIndex: 1,
    teacherAvatar: '',
    teacherName: '',
  );

  test('''UpdateLessonUsecase should launch an corresponding function of a repo,
  and return void ''', () async {
    //arrange
    when(() => mockRepository.updateLesson(any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tResultEntity);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.updateLesson(tResultEntity));
    verifyNoMoreInteractions(mockRepository);
  });
}
