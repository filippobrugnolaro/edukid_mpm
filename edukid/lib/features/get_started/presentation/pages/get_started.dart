import 'package:edukid/core/presentation/widgets/card.dart';
import 'package:edukid/core/presentation/widgets/clickableImg.dart';
import 'package:edukid/di_container.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/authentication/presentation/pages/login.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config/colors.dart' as app_colors;
import '../../../../core/presentation/widgets/dialog/dialog_factory.dart';

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final getStartedRepository = sl<GetStartedRepository>();
  int points = 0;

  @override
  void initState() {
    super.initState();
    getUpdatedPoints();
  }

  Future<void> getUpdatedPoints() async {
    final newPoints = await getStartedRepository.listenToUserPoints();
    setState(() {
      points = newPoints;
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'EduKid',
            style: TextStyle(fontSize: 2.5.h),
          ),
          actions: [
          IconButton(
            icon: const Icon(Icons.account_box_rounded),
            onPressed: () {
              // Perform action when the icon is pressed
              Navigator.of(context).pushNamed('profile');
            },
          ),
        ],
          backgroundColor: app_colors.orange,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              // Navigate to the sign in screen when the user Signs Out
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          child: Stack(
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
                          Text(
                            '$points',
                              style: TextStyle(
                                  fontSize: 3.h, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Hello there! What would you like to revise today?',
                              style: TextStyle(
                                  fontSize: 3.2.h, fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                          ),
                          const Expanded(flex: 1, child: ClickableImage()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CardWidget(
                              text: 'Maths',
                              imagePath: 'images/numbers.png',
                              borderColor: app_colors.fucsia,
                              goTo: 'math'),
                          SizedBox(width: 10.w),
                          const CardWidget(
                              text: 'Geography',
                              imagePath: 'images/geo.png',
                              borderColor: app_colors.blue,
                              goTo: 'geo'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CardWidget(
                              text: 'History',
                              imagePath: 'images/storia.png',
                              borderColor: app_colors.green,
                              goTo: 'storia'),
                          SizedBox(width: 10.w),
                          const CardWidget(
                              text: 'Science',
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
        ));
  }

  void dialogShow(BuildContext context) {
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
