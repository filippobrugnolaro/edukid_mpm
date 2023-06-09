import 'package:edukid/features/trivia/presentation/widgets/card.dart';
import 'package:edukid/features/trivia/presentation/widgets/clickableImg.dart';
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialog.dart';
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialogBloc.dart';
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetStartedPage();
  }
}

class GetStartedPage extends StatelessWidget {
  final DialogBloc _dialogBloc = DialogBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EduKid',
          style: TextStyle(fontSize: 2.5.h),
        ),
        backgroundColor: app_colors.orange,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(6.w, 6.w, 6.w, 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/coin.png',
                        height: 6.h,
                      ),
                      Text('200',
                          style: TextStyle(
                              fontSize: 2.5.h, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Ciao! Cosa vuoi imparare oggi?',
                          style: TextStyle(
                              fontSize: 3.2.h, fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                      Expanded(flex: 1, child: ClickableImage()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CardWidget(
                          text: 'Matematica',
                          imagePath: 'images/numbers.png',
                          borderColor: app_colors.fucsia,
                          goTo: 'math'),
                      SizedBox(width: 10.w),
                      const CardWidget(
                          text: 'Geografia',
                          imagePath: 'images/geo.png',
                          borderColor: app_colors.blue,
                          goTo: 'geo'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CardWidget(
                          text: 'Storia',
                          imagePath: 'images/storia.png',
                          borderColor: app_colors.green,
                          goTo: 'storia'),
                      SizedBox(width: 10.w),
                      const CardWidget(
                          text: 'Scienze',
                          imagePath: 'images/scienze.png',
                          borderColor: app_colors.orange,
                          goTo: 'scienze'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showdialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DialogFactory.getDialog(
              context: context,
              dialogType: DialogType.info,
              title: 'Tutorial',
              description: 'Ciao io sono Monky!');
        });
  }
}
