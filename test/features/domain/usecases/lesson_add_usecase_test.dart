import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/domain/usecases/lesson_add_usecase.dart';

class MockRepository extends Mock implements Repository {}

class MockLessonEntity extends Fake implements LessonEntity {}

void main() {
  late AddLessonUsecase usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = AddLessonUsecase(mockRepository);
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

  test('''AddLessonUsecase should launch an corresponding function of a repo,
  and return void ''', () async {
    //arrange
    when(() => mockRepository.addLesson(any()))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    final result = await usecase(tResultEntity);
    //assert
    expect(result, Right(await Future.value()));
    verify(() => mockRepository.addLesson(tResultEntity));
    verifyNoMoreInteractions(mockRepository);
  });
}
