import 'package:edukid/core/presentation/widgets/menuDrawer.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:sizer/sizer.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text(
            'Instructions',
            style: TextStyle(fontSize: 2.5.h),
          ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Now Scaffold.of(context) will work correctly
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
          backgroundColor: app_colors.orange,
        ),
        drawer: MenuDrawer(pageNumber: 3,),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Answer the questions correctly to earn 10 points per correct answer.',
                      style: TextStyle(fontSize: 10.sp), softWrap: true,),
                  ),
                  SizedBox(width: 2.w,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius
                      border: Border.all(
                        color: app_colors.orange, // Set border color
                        width: 2.0, // Set border width
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius again for clipping
                      child: Image.asset(
                        'images/earn10.png', // Replace with your image asset path
                        width: 35.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.5.h),
              const Divider(color: app_colors.grey,),
              SizedBox(height: 2.5.h),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius
                      border: Border.all(
                        color: app_colors.orange, // Set border color
                        width: 2.0, // Set border width
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius again for clipping
                      child: Image.asset(
                        'images/lost5.png', // Replace with your image asset path
                        width: 35.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Flexible(
                    child: Text(
                      'If your answer is wrong, you will lose 5 points.',
                      style: TextStyle(fontSize: 10.sp), softWrap: true,),
                  ),
                  
                ],
              ),
              SizedBox(height: 2.5.h),
              const Divider(color: app_colors.grey,),
              SizedBox(height: 2.5.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'The game will consist of multiple-choice questions. Only one answer is correct.',
                      style: TextStyle(fontSize: 10.sp), softWrap: true,),
                  ),
                  SizedBox(width: 5.w,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius
                      border: Border.all(
                        color: app_colors.orange, // Set border color
                        width: 2.0, // Set border width
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // Set border radius again for clipping
                      child: Image.asset(
                        'images/question.png', // Replace with your image asset path
                        width: 50.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  
                ],
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
        ),
      ),]
    ));
  }
}
