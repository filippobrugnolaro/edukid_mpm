import 'package:edukid/features/trivia/data/repositories/RandomTriviaRepositoryImpl.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';
import 'package:edukid/features/trivia/domain/usecases/GetRandomTriviaUseCase.dart';
import 'package:edukid/features/trivia/presentation/screens/getStarted/getStarted.dart';
import 'package:edukid/features/trivia/presentation/screens/login/login.dart';
import 'package:edukid/features/trivia/presentation/screens/question/questions.dart';
import 'package:edukid/features/trivia/presentation/config/colors.dart'
    as app_colors;
import 'package:flutter/material.dart';


class AppRouter {
  QuizRepo repo = QuizRepo();
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case 'getStarted':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GetStartedPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'math':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuestionPage(
            title: 'Matematica',
            color: app_colors.fucsia,
            quizRepo: repo,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'geo':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuestionPage(title: 'Geografia', color: app_colors.blue, quizRepo: repo),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'storia':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuestionPage(title: 'Storia', color: app_colors.green,quizRepo: repo),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'scienze':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              QuestionPage(title: 'scienze', color: app_colors.orange,quizRepo: repo,),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'login':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Scaffold(
            body: Center(child: Text("Blank")),
          ), //unknown screen,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
    }
  }

  FadeTransition _getSlideTransition(
      Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
