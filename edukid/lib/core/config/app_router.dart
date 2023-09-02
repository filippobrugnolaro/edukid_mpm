
import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/how_to_play_page.dart';
import 'package:edukid/features/authentication/presentation/pages/login.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:edukid/features/profile/presentation/pages/profile_page.dart';
import 'package:edukid/features/statistics/presentation/pages/statistics.dart';
import 'package:edukid/features/trivia_question/presentation/pages/questions.dart';
import 'package:flutter/material.dart';


class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case 'getStarted':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GetStartedPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'math':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuestionPage(
                title: 'Matematica',
                color: app_colors.fucsia,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'geo':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuestionPage(title: 'Geografia', color: app_colors.blue),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'storia':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuestionPage(title: 'Storia', color: app_colors.green),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'scienze':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const QuestionPage(title: 'Scienze', color: app_colors.orange),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'login':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
      case 'profile':
      return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
        case 'howtoplay':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              InstructionsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
        case 'statistics':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const StatisticsPage(),
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
