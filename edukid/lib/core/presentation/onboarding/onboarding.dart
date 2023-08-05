import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'content_model.dart';
import '../../../../core/config/colors.dart' as app_colors;

class OnboardingScreen extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: PageView.builder(
          controller: _controller,
          itemCount: content.length,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, i) {
            return Container(
              margin: EdgeInsets.all(3.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(content[i].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp,),),
                  SizedBox(height: 2.h),
                  Text(content[i].description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp,height: 2,),),
                  SizedBox(height: 4.h),
                  Image.asset(
                    content[i].image,
                    width: 50.w,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            content.length,
            (index) => buildDot(context, index),
          )
        ],
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.all(6.h),
        color: app_colors.orange,
        child: ElevatedButton(
          onPressed: () {
            if (currentIndex == content.length - 1) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const GetStartedPage()),
                (route) => false,
              );
            } else {
              _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn);
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(2.h)),
            backgroundColor: MaterialStateProperty.all<Color>(
                app_colors.orange), // Set the background color
          ),
          child: Text(
              currentIndex == content.length - 1 ? "Yes I am ready!" : "Next",
              style: TextStyle(fontSize: 13.0.sp, color: app_colors.white)),
        ),
      )
    ]));
  }

  Widget buildDot(BuildContext context, int index) {
    return Container(
      height: 1.5.h,
      width: currentIndex == index ? 4.h : 1.5.h,
      margin: EdgeInsets.only(right: 1.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index ? app_colors.orange : app_colors.grey),
    );
  }
}
