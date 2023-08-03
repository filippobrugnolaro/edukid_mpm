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
  bool isLoaded = false;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    if(await getStartedRepository.isDeviceConnected()) {
      await copyCurrentToLatest();
      await resetCurrentStatistics();
      await getUpdatedPoints();
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> getUpdatedPoints() async {
    final newPoints = await getStartedRepository.listenToUserPoints();
    setState(() {
      points = newPoints;
      isLoaded = true;
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
          title: const Text(
            'EduKid'
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
        drawer: MenuDrawer(
        pageNumber: 0,
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
                    image: AssetImage('assets/images/doodle.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(6.w, 6.w, 6.w, 15.w),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isLoaded ?
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/coin.png',
                                      height: 6.h,
                                    ),
                                    Text(
                                        '$points',
                                        style: TextStyle(
                                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                  ]
                              )
                                  : const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(app_colors.orange),
                                  )
                              )
                            ],),
                          ElevatedButton(

                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(2.h)),
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
                      SizedBox(height:5.h),
                      Text(
                        'Hello there! What would you like to try today?',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      SizedBox(height:5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CardWidget(
                              text: 'Maths',
                              imagePath: 'assets/images/numbers.png',
                              borderColor: app_colors.fucsia,
                              goTo: 'math'),
                          SizedBox(width: 10.w),
                          const CardWidget(
                              text: 'Geography',
                              imagePath: 'assets/images/geo.png',
                              borderColor: app_colors.blue,
                              goTo: 'geo'),
                        ],
                      ),
                      SizedBox(height:5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CardWidget(
                              text: 'History',
                              imagePath: 'assets/images/storia.png',
                              borderColor: app_colors.green,
                              goTo: 'storia'),
                          SizedBox(width: 10.w),
                          const CardWidget(
                              text: 'Science',
                              imagePath: 'assets/images/scienze.png',
                              borderColor: app_colors.orange,
                              goTo: 'scienze'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if(!isConnected)
              AlertDialog(
                actionsPadding: const EdgeInsets.all(20),
                title: const Text('Error'),
                content: const Text('It seems there is no internet connection. Please connect to a wifi or mobile data network.'),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
                      onPressed: () {
                        Navigator.pushNamed(context, "getStarted");
                        if(isConnected) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Ok')),
                ],
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
