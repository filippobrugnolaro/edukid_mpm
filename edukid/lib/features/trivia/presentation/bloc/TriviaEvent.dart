import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetRandomTriviaEvent extends TriviaEvent {
  final String typeQuestion;
  final String numberQuestion;

  GetRandomTriviaEvent(this.typeQuestion, this.numberQuestion);

  @override
  List<Object> get props => [typeQuestion, numberQuestion];
}