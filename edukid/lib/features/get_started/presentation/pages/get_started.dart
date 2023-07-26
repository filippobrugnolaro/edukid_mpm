import 'package:edukid/core/presentation/widgets/card.dart';
import 'package:edukid/core/presentation/widgets/menuDrawer.dart';
import 'package:edukid/di_container.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/authentication/presentation/pages/login.dart';
import 'package:edukid/features/get_started/domain/repositories/get_started_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config/colors.dart' as app_colors;

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final getStartedRepository = sl<GetStartedRepository>();
  int points = 0;

  @override
  void initState() {
    super.initState();
    copyCurrentToLatest();
    resetCurrentStatistics();
    getUpdatedPoints();
  }

  Future<void> getUpdatedPoints() async {
    final newPoints = await getStartedRepository.listenToUserPoints();
    setState(() {
      points = newPoints;
    });
  }

  Future<void> copyCurrentToLatest() async {
    await getStartedRepository.copyCurrentToLatest();
  }

  Future<void> resetCurrentStatistics() async {
    await getStartedRepository.resetAllCurrentToZero();
    await getStartedRepository.setResetToDo(false);
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
        drawer: MenuDrawer(pageNumber: -1,),
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
                                  fontSize: 3.h, fontWeight: FontWeight.bold)),
                      ],),
                          ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                app_colors.orange), // Set the background color
                          ),
                          onPressed: () {
                            showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return getDialog(context);
                                  });
                          },
                          child: const Text('How to play'),
                        ),
                        ],
                      ),
                      Text(
                              'Hello there! What would you like to try today?',
                              style: TextStyle(
                                  fontSize: 3.2.h, fontWeight: FontWeight.bold),
                              softWrap: true,
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

  Widget getDialog(BuildContext context){
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.info,
              color: app_colors.orange,
              size: (SizerUtil.deviceType == DeviceType.mobile ? null : 4.0.w)),
          const SizedBox(
            width: 10,
          ),
          const Text('Tutorial')
        ],
      ),
      content: const Text('Have fun and challenge your friends while learning!\nFor each correct answer you will earn 10 coins but be careful! If your answer is wrong you will lose 5.'
      ),
      actionsPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
            onPressed: () {Navigator.pop(context);},
            child: const Text('Close'))
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
