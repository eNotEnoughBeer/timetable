import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/usecases/auth_forgot_password.dart';
import 'package:timetable/feature/domain/usecases/auth_is_logged_in_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_login_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_logout_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_signup_usecase.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ForgotPasswordUsecase forgotPasswordUsecase;
  final IsLoggedInUsecase isLoggedInUsecase;
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;

  AuthCubit({
    required this.forgotPasswordUsecase,
    required this.isLoggedInUsecase,
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signUpUsecase,
  }) : super(const InitialAuthState());

  bool checkInput(bool needChangeState,
      {String? name, String? email, String? password}) {
    if (needChangeState) {
      emit(const InProgress());
    }
    if (email != null) {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      );
      if (email.isEmpty) {
        if (needChangeState) {
          emit(const UnAuthenticated(
              message: 'адреса електронної пошти порожня'));
        }
        return false;
      }

      if (!emailRegExp.hasMatch(email) || email.length > 30) {
        if (needChangeState) {
          emit(const UnAuthenticated(
              message: 'помилка у адресі електронної пошти'));
        }
        return false;
      }
    }

    if (password != null) {
      if (password.isEmpty) {
        if (needChangeState) {
          emit(const UnAuthenticated(message: 'пароль не введено'));
        }
        return false;
      }

      final passwordRegExp = RegExp(r'^[A-Za-z\d@$!%*?&]{8,}$');
      if (!passwordRegExp.hasMatch(password) || password.length > 12) {
        if (needChangeState) {
          emit(const UnAuthenticated(
              message: 'довжина пароля 8-12 символів.\nлітери - англійські'));
        }
        return false;
      }
    }

    if (name != null) {
      if (name.isEmpty) {
        if (needChangeState) {
          emit(const UnAuthenticated(message: 'ім\'я не введено'));
        }
        return false;
      }

      if (name.length > 20) {
        if (needChangeState) {
          emit(
              const UnAuthenticated(message: 'довжина імени - до 20 символів'));
        }
        return false;
      }
    }
    return true;
  }

  Future<void> isLoggedUser() async {
    final res = isLoggedInUsecase();
    if (res) {
      emit(const Authenticated());
    } else {
      emit(const UnAuthenticated());
    }
  }

  Future<void> logIn(String email, String password) async {
    emit(const InProgress());
    final failureOrData = await loginUsecase(email, password);
    failureOrData.fold((error) {
      emit(UnAuthenticated(message: (error as ServerFailure).message));
    }, (data) {
      emit(const Authenticated());
    });
  }

  Future<void> logOut() async {
    final failureOrData = await logoutUsecase();
    failureOrData.fold((error) {
      emit(UnAuthenticated(message: (error as ServerFailure).message));
    }, (data) {
      emit(const UnAuthenticated());
    });
  }

  Future<void> forgotPassword(String email) async {
    emit(const InProgress());
    final failureOrData = await forgotPasswordUsecase(email);
    failureOrData.fold((error) {
      emit(UnAuthenticated(message: (error as ServerFailure).message));
    }, (data) {
      emit(const UnAuthenticated(
        message:
            'на вказаний e-mail було відправлено листа з посиланням на скидання паролю',
      ));
    });
  }

  Future<void> signUp(String email, String password, String userName) async {
    emit(const InProgress());

    final failureOrData = await signUpUsecase(email, password, userName);
    failureOrData.fold((error) {
      emit(UnAuthenticated(message: (error as ServerFailure).message));
    }, (data) {
      emit(const Authenticated());
    });
  }
}
