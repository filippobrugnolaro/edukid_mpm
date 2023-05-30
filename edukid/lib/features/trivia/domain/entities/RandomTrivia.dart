import 'package:equatable/equatable.dart';

class RandomTrivia extends Equatable {
  final String question;
  final List<String> options;
  final String answer;

  const RandomTrivia(
      {required this.question, required this.options, required this.answer});

  @override
  List<Object?> get props => [question, options, answer];
}
