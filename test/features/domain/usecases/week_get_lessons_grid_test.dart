import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/lesson_grid_model.dart';
import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:timetable/feature/domain/usecases/week_get_lessons_grid.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late WeekGridLessonsGet usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = WeekGridLessonsGet(mockRepository);
  });

  test('''WeekGridLessonsGet should launch an corresponding function of a repo,
  and return a schedule grid [5][8] size''', () async {
    const String key = 'test key';
    final List<List<LessonGridModel>> testSchedule = List.generate(
        5, (index) => List.generate(8, (i) => LessonGridModel.emptyElement()));

    final List<List<LessonGridEntity>> tGrid = testSchedule;
    //arrange
    when(() => mockRepository.getLessonsWeekGrid(any()))
        .thenAnswer((_) async => Right(tGrid));
    //act
    final result = await usecase(key);
    var resultLength = 0;
    result.fold((l) => null, (r) => resultLength = r.length);
    //assert
    expect(result, Right(tGrid));
    expect(resultLength, 5);
    verify(() => mockRepository.getLessonsWeekGrid(key));
    verifyNoMoreInteractions(mockRepository);
  });
}
