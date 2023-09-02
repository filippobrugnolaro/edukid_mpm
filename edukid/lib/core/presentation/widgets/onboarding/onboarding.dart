import 'package:edukid/di_container.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';
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
  final getStartedRepository = sl<GetStartedRepository>();
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

  Future<void> setWizardToDisplayToFalse() async {
    await getStartedRepository.setWizardToDisplay(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea( child:
        Column(children: [
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
              child:
                  SingleChildScrollView(
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
                    )
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (currentIndex == content.length - 1) {
                  setWizardToDisplayToFalse();
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
                  currentIndex == content.length - 1 ? "Si sono pronto!" : "Prossima",
                  style: TextStyle(fontSize: 13.0.sp, color: app_colors.white)),
            ),
            SizedBox(height:1.5.h),
            InkWell(
              onTap: () {
                // Handle the "Skip" action
                setWizardToDisplayToFalse();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const GetStartedPage()),
                  (route) => false,
                );
              },
              child: Text(
                "Salta",
                style: TextStyle(
                  color: app_colors.orange,
                  fontSize: 13.sp
                ),
              ),
            ),])
      )
    ])));
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
