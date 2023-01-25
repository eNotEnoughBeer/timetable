import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/lesson_grid_model.dart';
import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:timetable/feature/domain/usecases/week_set_lessons_grid.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late WeekGridLessonsSet usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = WeekGridLessonsSet(mockRepository);
  });

  test('''WeekGridLessonsSet should launch an corresponding function of a repo,
  and return void''', () async {
    const String key = 'test key';
    final List<List<LessonGridModel>> testSchedule = List.generate(
        3, (index) => List.generate(2, (i) => LessonGridModel.emptyElement()));

    final List<List<LessonGridEntity>> tGrid = testSchedule;
    //arrange
    when(() => mockRepository.setLessonsWeekGrid(any(), tGrid))
        .thenAnswer((_) async => Right(await Future.value()));
    //act
    await usecase(key, tGrid);
    //assert
    verify(() => mockRepository.setLessonsWeekGrid(key, tGrid));
    verifyNoMoreInteractions(mockRepository);
  });
}
