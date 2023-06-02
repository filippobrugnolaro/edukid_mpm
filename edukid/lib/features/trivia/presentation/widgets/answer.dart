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
    return SizedBox(
        width: 55.w,
        height: 8.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(app_colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(16.0)), // Set the desired padding
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
                color: borderColor, width: 3.0)), // Set the desired border
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    15.0), // Set the desired border radius
              ),
            ),
          ),
          onPressed: () {},
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(color: app_colors.black, fontSize: 2.h),
              ),
            ],
          ),
        ));
  }
}
