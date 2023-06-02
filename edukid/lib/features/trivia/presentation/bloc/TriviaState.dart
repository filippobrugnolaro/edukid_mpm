import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends TriviaState {}

class Loading extends TriviaState {}

class Loaded extends TriviaState {
  final RandomTrivia trivia;

  Loaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class Error extends TriviaState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}