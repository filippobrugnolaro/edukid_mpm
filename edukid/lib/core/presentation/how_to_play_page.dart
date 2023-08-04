import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/widgets/menu_drawer.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: const Text(
            'Instructions'),
      
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Now Scaffold.of(context) will work correctly
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
          backgroundColor: app_colors.orange,
        ),
        drawer: const MenuDrawer(pageNumber: 3,),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/doodle.png'),
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
              Text(
                '1. The game will consist of multiple choice questions categorized in different subjects.\nOnly one answer is correct.',
                style: TextStyle(fontSize: 12.5.sp), softWrap: true,),
              SizedBox(height: 2.h),
              Text(
                '2. Answer the questions correctly to earn 10 points per correct answer.',
                style: TextStyle(fontSize: 12.5.sp), softWrap: true,),
              SizedBox(height: 2.h),
              Text(
                '3. If your answer is wrong, you will lose 5 points.',
                style: TextStyle(fontSize: 12.5.sp), softWrap: true,),
              SizedBox(height: 2.h),
              Text(
                "4. You can keep up with your improvement in the 'Statistics' page.\nTry to beat your score and improve day by day!",
                style: TextStyle(fontSize: 12.5.sp), softWrap: true,),
              SizedBox(height: 5.h),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange, padding: EdgeInsets.all(2.h)),
                  onPressed: () {
                    // Navigate to the quiz page when the user taps the "Start Quiz" button
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartedPage(),
                      ),
                    );
                  },
                  child: Text('Start to play!', style: TextStyle(fontSize: 13.sp)),
                ),
              ),
            ],
          ),
        ),
      ),]
    ));
  }
}
