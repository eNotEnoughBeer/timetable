import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object?> get props => [];
}

// помилки серверної частини (немає з'єднання, поганий пароль і т.і.)
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// помилки цього класу для внутрішнього користування
// користувач нічого не побачить на екрані
class CacheFailure extends Failure {}
