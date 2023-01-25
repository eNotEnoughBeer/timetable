part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class InitialAuthState extends AuthState {
  const InitialAuthState();

  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  const Authenticated();

  @override
  List<Object?> get props => [];
}

class InProgress extends AuthState {
  const InProgress();

  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  final String? message;
  const UnAuthenticated({this.message});

  @override
  List<Object?> get props => [];
}
