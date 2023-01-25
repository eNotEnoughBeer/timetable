import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/usecases/peron_get_user_cached_password.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_data_usecase.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_uid.dart';
import 'package:timetable/feature/domain/usecases/person_update_user_data_usecase.dart';
part 'user_credentials_state.dart';

class UserCredentialsCubit extends Cubit<UserCredentialsState> {
  final GetUserDataUsecase getUserDataUsecase;
  final UpdateUserDataUsecase updateUserDataUsecase;
  final GetUserCachedPasswordUsecase getUserCachedPasswordUsecase;
  final GetUserUidUsecase getUserUidUsecase;
  UserCredentialsCubit({
    required this.getUserDataUsecase,
    required this.updateUserDataUsecase,
    required this.getUserCachedPasswordUsecase,
    required this.getUserUidUsecase,
  }) : super(const InitialState());

  String get getUserPassword => getUserCachedPasswordUsecase();
  String get getUserUid => getUserUidUsecase();

  Future<void> userData() async {
    emit(const InProgress());
    final failureOrData = await getUserDataUsecase();
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (data) {
      emit(Succeed(personData: data));
    });
  }

  Future<void> updateUserData(
    String name,
    String email,
    String password,
    String avatar,
    String role,
  ) async {
    emit(const InProgress());
    final userData = PersonEntity(
      uid: getUserUid,
      name: name,
      email: email,
      role: role,
      avatar: avatar,
    );
    final failureOrData =
        await updateUserDataUsecase(userData, getUserPassword);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (data) {
      emit(const Failed(message: 'дані оновлено'));
      this.userData();
    });
  }
}
