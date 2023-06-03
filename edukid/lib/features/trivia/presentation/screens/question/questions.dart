import 'package:edukid/features/trivia/presentation/widgets/answer.dart';
import 'package:edukid/features/trivia/presentation/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class QuestionPage extends StatelessWidget {
  final Color color;
  final String title;

  const QuestionPage({
    Key? key,
    required this.color,
    required this.title,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 2.5.h),),
        centerTitle: true,
        backgroundColor: color,
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
                AnswerOption(text: 'risp1', borderColor: color),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp2', borderColor: color),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp3', borderColor: color),
                SizedBox(height: 2.h),
                AnswerOption(text: 'risp4', borderColor: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
