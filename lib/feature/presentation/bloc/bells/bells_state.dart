part of 'bells_cubit.dart';

abstract class BellState extends Equatable {
  const BellState();

  @override
  List<Object?> get props => [];
}

class InitialState extends BellState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class InProgress extends BellState {
  const InProgress();

  @override
  List<Object?> get props => [];
}

class Succeed extends BellState {
  final List<SchoolBellEntity>? data;
  const Succeed({this.data});

  @override
  List<Object?> get props => [data];
}

class Failed extends BellState {
  final String? message;
  const Failed({this.message});

  @override
  List<Object?> get props => [message];
}
