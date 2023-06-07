import 'package:edukid/features/trivia/presentation/config/colors.dart'
    as app_colors;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final Color borderColor;
  //final VoidCallback onPressed;

  const AnswerOption({
    Key? key,
    required this.text,
    required this.borderColor,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.w,
      height: 8.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(color: app_colors.black, fontSize: 2.h),
          ),
        ],
      ),
    );
  }
}
