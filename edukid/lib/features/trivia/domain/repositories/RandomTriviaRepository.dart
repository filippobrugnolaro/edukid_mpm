import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/Failure.dart';
import '../entities/RandomTrivia.dart';

abstract class RandomTriviaRepository {
  Future<Either<Failure, RandomTrivia>> getRandomTrivia(
      String typeQuestion, String numberQuestion);
}

class QuizRepo {
  RandomTrivia getQuestion() {
    List<RandomTrivia> triviaList = [
      RandomTrivia(
        question: "Qual è la capitale dell'Italia?",
        options: ["Roma", "Milano", "Napoli", "Firenze"],
        answer: "Roma",
      ),
      RandomTrivia(
        question:
            "Quale pianeta del sistema solare è conosciuto come il pianeta rosso?",
        options: ["Marte", "Venere", "Giove", "Saturno"],
        answer: "Marte",
      ),
      RandomTrivia(
        question: "Chi ha scritto il romanzo 'Orgoglio e pregiudizio'?",
        options: [
          "Jane Austen",
          "Emily Brontë",
          "Charlotte Brontë",
          "Virginia Woolf"
        ],
        answer: "Jane Austen",
      ),
      RandomTrivia(
        question: "Qual è il fiume più lungo del mondo?",
        options: ["Nilo", "Amazzonia", "Mississippi", "Yangtze"],
        answer: "Nilo",
      ),
      RandomTrivia(
        question: "In quale anno è stato lanciato il primo iPhone?",
        options: ["2007", "2005", "2009", "2003"],
        answer: "2007",
      ),
    ];

    Random random = Random();
    return triviaList[random.nextInt(triviaList.length)];
  }
}
