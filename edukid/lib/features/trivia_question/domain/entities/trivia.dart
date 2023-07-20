import 'package:equatable/equatable.dart';

class Trivia extends Equatable {
  final String question;
  final List<String> options;
  final String answer;

  const Trivia(
      {required this.question, required this.options, required this.answer});

  @override
  List<Object?> get props => [question, options, answer];
}