import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/usecases/bells_add_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_delete_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_get_all_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_update_usecase.dart';

part 'bells_state.dart';

class BellsCubit extends Cubit<BellState> {
  final AddBellUsecase addBellUsecase;
  final DeleteBellUsecase deleteBellUsecase;
  final UpdateBellUsecase updateBellUsecase;
  final GetBellsUsecase getBellsUsecase;

  BellsCubit({
    required this.addBellUsecase,
    required this.deleteBellUsecase,
    required this.updateBellUsecase,
    required this.getBellsUsecase,
  }) : super(const InitialState());

  Future<bool> addBell(SchoolBellEntity bellEntity) async {
    List<SchoolBellEntity>? entInDb;
    if (state is Failed) {
      final failureOrData = await getBellsUsecase();
      failureOrData.fold((error) {
        emit(Failed(message: (error is ServerFailure) ? error.message : ''));
        return false;
      }, (data) {
        entInDb = data;
      });
    }
    if (state is Succeed) {
      entInDb = (state as Succeed).data;
    }
    emit(const InProgress());

    if (entInDb != null) {
      for (var element in entInDb!) {
        if (element.lessonNumber == bellEntity.lessonNumber) {
          emit(const Failed(message: 'Урок з таким номером вже занесено'));
          return false;
        }
      }
    }

    final failureOrData = await addBellUsecase(bellEntity);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
      return false;
    }, (_) async {
      await getBells();
    });
    return true;
  }

  Future<void> delBell(SchoolBellEntity bellEntity) async {
    emit(const InProgress());
    final failureOrData = await deleteBellUsecase(bellEntity);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (_) async {
      await getBells();
    });
  }

  Future<void> updateBell(SchoolBellEntity bellEntity) async {
    emit(const InProgress());
    final failureOrData = await updateBellUsecase(bellEntity);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (_) async {
      await getBells();
    });
  }

  Future<void> getBells() async {
    emit(const InProgress());
    final failureOrData = await getBellsUsecase();
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (data) {
      emit(Succeed(data: data));
    });
  }
}
