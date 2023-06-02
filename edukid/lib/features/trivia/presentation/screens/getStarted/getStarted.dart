import 'package:edukid/features/trivia/presentation/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetStartedPage();
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edukid'),
        backgroundColor: app_colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Ciao! Cosa vuoi imparare oggi?',
              style: TextStyle(fontSize: 3.2.h, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CardWidget(
                    text: 'MATEMATICA',
                    imagePath: 'images/numbers.png',
                    borderColor: app_colors.fucsia,
                    goTo: 'math'),
                SizedBox(width: 10.w),
                const CardWidget(
                    text: 'GEOGRAFIA',
                    imagePath: 'images/geo.png',
                    borderColor: app_colors.blue,
                    goTo: 'geografia'),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardWidget(
                    text: 'STORIA',
                    imagePath: 'images/storia.png',
                    borderColor: app_colors.green,
                    goTo: 'storia'),
                SizedBox(width: 10.w),
                CardWidget(
                    text: 'SCIENZE',
                    imagePath: 'images/scienze.png',
                    borderColor: app_colors.orange,
                    goTo: 'scienze'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
