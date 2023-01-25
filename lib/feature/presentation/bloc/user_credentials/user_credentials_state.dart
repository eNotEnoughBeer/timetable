part of 'user_credentials_cubit.dart';

abstract class UserCredentialsState extends Equatable {
  const UserCredentialsState();

  @override
  List<Object?> get props => [];
}

class InitialState extends UserCredentialsState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class InProgress extends UserCredentialsState {
  const InProgress();

  @override
  List<Object?> get props => [];
}

class Succeed extends UserCredentialsState {
  final PersonEntity personData;
  const Succeed({required this.personData});

  @override
  List<Object?> get props => [personData];
}

class Failed extends UserCredentialsState {
  final String? message;
  const Failed({this.message});

  @override
  List<Object?> get props => [message];
}
