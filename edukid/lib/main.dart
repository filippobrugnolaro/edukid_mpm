import 'package:sizer/sizer.dart';

import 'features/trivia/presentation/config/app_router.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:edukid/DependencyInjectionContainer.dart' as di;
=======
import 'features/trivia/presentation/config/themes.dart';
>>>>>>> Stashed changes

Future<void> main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, DeviceType) {
      return MaterialApp(
        title: 'Edukid',
        theme: AppTheme.lightTheme,
        initialRoute: 'getStarted',
        onGenerateRoute: AppRouter().onGenerateRoute,
      );
    });
  }
}
