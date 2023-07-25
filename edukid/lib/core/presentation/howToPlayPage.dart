import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:sizer/sizer.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
        backgroundColor: app_colors.orange,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
        padding: EdgeInsets.all(5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.0.h),
             Text(
              '1. Answer the questions correctly to earn 10 points per correct answer.',
              style: TextStyle(fontSize: 10.sp),
            ),
             Text(
              '2. If your answer is wrong, you will lose 5 points.',
              style: TextStyle(fontSize: 10.sp),
            ),
             Text(
              '3. The game will consist of multiple-choice questions. Only one answer is correct.',
              style: TextStyle(fontSize: 10.sp),
            ),
            SizedBox(height: 5.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange, padding: EdgeInsets.all(2.h)),
                onPressed: () {
                  // Navigate to the quiz page when the user taps the "Start Quiz" button
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetStartedPage(),
                    ),
                  );
                },
                child: Text('Start to play!', style: TextStyle(fontSize: 10.sp)),
              ),
            ),
          ],
        ),
      ),]
    ));
  }
}
