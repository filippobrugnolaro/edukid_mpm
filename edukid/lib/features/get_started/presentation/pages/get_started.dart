import 'package:edukid/core/presentation/widgets/card.dart';
import 'package:edukid/core/presentation/widgets/menu_drawer.dart';
import 'package:edukid/core/presentation/widgets/onboarding/onboarding.dart';
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
  List<int> currentDone = [];
  bool wizard = false;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    if (await getStartedRepository.isDeviceConnected()) {
      await copyCurrentToLatest();
      await resetCurrentStatistics();
      await getUpdatedPoints();
      await getCurrentDone();
      final wizardValue = await getWizardToDisplay();
      setState(() {
        wizard = wizardValue;
        isLoaded = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<bool> getWizardToDisplay() async {
    return await getStartedRepository.getWizardToDisplay();
  }

  Future<void> getUpdatedPoints() async {
    final newPoints = await getStartedRepository.listenToUserPoints();
    setState(() {
      points = newPoints;
    });
  }

  Future<void> getCurrentDone() async {
    final List<int> done = await getStartedRepository.getAllCurrentDone();
    setState(() {
      currentDone = List.from(done);
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
    return wizard == false
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('EduKid'),
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
            drawer: const MenuDrawer(
              pageNumber: 0,
            ),
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  // Navigate to the sign in screen when the user Signs Out
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
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
                  SingleChildScrollView(
                    child: Center(
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
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/coin.png',
                                            height: 6.h,
                                          ),
                                          isLoaded
                                              ? Text('$points',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          app_colors.orange),
                                                ),
                                        ])
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline_rounded,
                                      color: app_colors.orange),
                                  iconSize: 6.h,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return getDialog(context);
                                        });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
                            Text(
                              'Hello there! What would you like to try today?',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const CardWidget(
                                        text: 'Maths',
                                        imagePath: 'assets/images/numbers.png',
                                        borderColor: app_colors.fucsia,
                                        goTo: 'math'),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    isLoaded && currentDone[0] == 0
                                        ? Row(children: [
                                            const Icon(
                                              Icons.circle,
                                              color: app_colors.red,
                                            ),
                                            SizedBox(width: 0.5.w),
                                            Builder(
                                              builder: (BuildContext context) {
                                                // Create a MediaQuery with a custom textScaleFactor
                                                final customMediaQuery = MediaQuery.of(context).copyWith(
                                                  textScaleFactor: 1.0, // Adjust the text scale factor as needed
                                                );
                                                return MediaQuery(
                                                  data: customMediaQuery,
                                                  child: Text(
                                                    'No answer!',
                                                    style: TextStyle(color: app_colors.red, fontSize: 11.sp),
                                                  ),
                                                );
                                              },
                                            )
                                          ])
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  children: [
                                    const CardWidget(
                                        text: 'Geography',
                                        imagePath: 'assets/images/geo.png',
                                        borderColor: app_colors.blue,
                                        goTo: 'geo'),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    isLoaded && currentDone[1] == 0
                                        ? Row(children: [
                                            const Icon(
                                              Icons.circle,
                                              color: app_colors.red,
                                            ),
                                            SizedBox(width: 0.5.w),
                                            Builder(
                                              builder: (BuildContext context) {
                                                // Create a MediaQuery with a custom textScaleFactor
                                                final customMediaQuery = MediaQuery.of(context).copyWith(
                                                  textScaleFactor: 1.0, // Adjust the text scale factor as needed
                                                );
                                                return MediaQuery(
                                                  data: customMediaQuery,
                                                  child: Text(
                                                    'No answer!',
                                                    style: TextStyle(color: app_colors.red, fontSize: 11.sp),
                                                  ),
                                                );
                                              },
                                            )
                                          ])
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const CardWidget(
                                        text: 'History',
                                        imagePath: 'assets/images/storia.png',
                                        borderColor: app_colors.green,
                                        goTo: 'storia'),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    isLoaded && currentDone[2] == 0
                                        ? Row(children: [
                                            const Icon(
                                              Icons.circle,
                                              color: app_colors.red,
                                            ),
                                            SizedBox(width: 0.5.w),
                                            Builder(
                                              builder: (BuildContext context) {
                                                // Create a MediaQuery with a custom textScaleFactor
                                                final customMediaQuery = MediaQuery.of(context).copyWith(
                                                  textScaleFactor: 1.0, // Adjust the text scale factor as needed
                                                );
                                                return MediaQuery(
                                                  data: customMediaQuery,
                                                  child: Text(
                                                    'No answer!',
                                                    style: TextStyle(color: app_colors.red, fontSize: 11.sp),
                                                  ),
                                                );
                                              },
                                            )
                                          ])
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  children: [
                                    const CardWidget(
                                        text: 'Science',
                                        imagePath: 'assets/images/scienze.png',
                                        borderColor: app_colors.orange,
                                        goTo: 'scienze'),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    isLoaded && currentDone[3] == 0
                                        ? Row(children: [
                                            const Icon(
                                              Icons.circle,
                                              color: app_colors.red,
                                            ),
                                            SizedBox(width: 0.5.w),
                                            Builder(
                                              builder: (BuildContext context) {
                                                // Create a MediaQuery with a custom textScaleFactor
                                                final customMediaQuery = MediaQuery.of(context).copyWith(
                                                  textScaleFactor: 1.0, // Adjust the text scale factor as needed
                                                );
                                                return MediaQuery(
                                                    data: customMediaQuery,
                                                    child: Text(
                                                      'No answer!',
                                                      style: TextStyle(color: app_colors.red, fontSize: 11.sp),
                                                    ),
                                                );
                                              },
                                            )
                                          ])
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isConnected)
                    AlertDialog(
                      actionsPadding: const EdgeInsets.all(20),
                      title: Text('Error', style: TextStyle(fontSize: 14.sp)),
                      content: SingleChildScrollView(
                        child: Text(
                            'It seems there is no internet connection. Please connect to a wifi or mobile data network.',
                            style: TextStyle(fontSize: 13.sp)),),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h),
                                backgroundColor: app_colors.orange),
                            onPressed: () {
                              Navigator.pushNamed(context, "getStarted");
                              if (isConnected) {
                                Navigator.of(context).pop();
                              }
                            },
                            child:
                                Text('Ok', style: TextStyle(fontSize: 13.sp))),
                      ],
                    ),
                ],
              ),
            ))
        : OnboardingScreen();
  }

  Widget getDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.info,
              color: app_colors.orange,
              size: (SizerUtil.deviceType == DeviceType.mobile ? null : 4.0.w)),
          const SizedBox(
            width: 10,
          ),
          Text('Tutorial', style: TextStyle(fontSize: 14.sp))
        ],
      ),
      content: SingleChildScrollView
        (child: Text(
          'For each correct answer you will earn  5 coins but be careful! If your answer is wrong you will lose 3.',
          style: TextStyle(fontSize: 13.sp)),),
      actionsPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: app_colors.orange,
              padding: EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close', style: TextStyle(fontSize: 13.sp)))
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
