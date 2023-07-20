import 'dart:convert';

import 'package:edukid/features/trivia_question/domain/entities/trivia.dart';


class TriviaModel extends Trivia {
  const TriviaModel(
      {required String question,
        required List<String> options,
        required String answer})
      : super(question: question, options: options, answer: answer);

  factory TriviaModel.fromJson(Map<String, dynamic> json) {

    List<String> optionsList = [];
    final optionsDecoded = json["options"];
    for(int i=1; i<5; i++) {
      optionsList.add(optionsDecoded["option" + i.toString()]);
    }

    return TriviaModel(
        question: json["question_text"],
        options: optionsList,
        answer: json["answer"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "question_text": question,
      "options": json.encode(options),
      "answer": answer
    };
  }
}