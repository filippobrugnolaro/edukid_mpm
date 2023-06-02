import 'package:edukid/features/trivia/presentation/widgets/answer.dart';
import 'package:edukid/features/trivia/presentation/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class MathQuiz extends StatelessWidget {
  const MathQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MathQuizPage();
  }
}

class MathQuizPage extends StatelessWidget {
  const MathQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matematica'),
        backgroundColor: app_colors.fucsia,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'domanda',
              style: TextStyle(fontSize: 3.2.h),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnswerOption(text: 'risp1', borderColor: app_colors.fucsia),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp2', borderColor: app_colors.fucsia),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp3', borderColor: app_colors.fucsia),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp4', borderColor: app_colors.fucsia),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
