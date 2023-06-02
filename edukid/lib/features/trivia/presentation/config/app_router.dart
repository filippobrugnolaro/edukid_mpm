import 'package:edukid/features/trivia/presentation/screens/getStarted/getStarted.dart';
import 'package:edukid/features/trivia/presentation/screens/math/math.dart';
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
              const MathQuizPage(),
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
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _getSlideTransition(animation, child);
          },
        );
    }
  }

  SlideTransition _getSlideTransition(Animation animation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
