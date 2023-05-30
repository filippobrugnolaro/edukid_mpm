import 'dart:convert';

import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';

class RandomTriviaModel extends RandomTrivia {
  const RandomTriviaModel(
      {required String question,
      required List<String> options,
      required String answer})
      : super(question: question, options: options, answer: answer);

  factory RandomTriviaModel.fromJson(Map<String, dynamic> json) {
    return RandomTriviaModel(
      question: json['question_text'],
      options: (json['options'] as List<String>),
      answer: json['answer']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_text' : question,
      'options' : json.encode(options),
      'answer' : answer
    };
  }
}
