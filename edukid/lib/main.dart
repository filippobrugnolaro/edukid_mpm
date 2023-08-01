import 'package:edukid/core/config/themes.dart';
import 'package:edukid/di_container.dart' as di;
import 'package:edukid/di_container.dart';
import 'package:edukid/features/authentication/domain/repositories/auth_repository.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'core/config/app_router.dart';
import 'features/authentication/presentation/pages/login.dart';

Future<void> main() async {
  await di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      projectId: "edu-kid",
      messagingSenderId: "208548965320",
      apiKey: 'AIzaSyCw6ARVwXQBYF5HibwlTt0DAumF6IOImIU',
      authDomain: 'AIzaSyCw6ARVwXQBYF5HibwlTt0DAumF6IOImIU',
      databaseURL:
          'https://edu-kid-default-rtdb.europe-west1.firebasedatabase.app',
      appId: "1:208548965320:web:8d0aa6affc3a866cb8eefd",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return RepositoryProvider(
        create: (context) => sl<AuthRepository>(),
        child: BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: Sizer(builder: (context, orientation, DeviceType) {
              return MaterialApp(
                title: 'Edukid',
                theme: AppTheme.lightTheme,
                home: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                      if (snapshot.hasData) {
                        return GetStartedPage();
                      }
                      // Otherwise, they're not signed in. Show the sign in page.
                      return const LoginScreen();
                    }),
                onGenerateRoute: AppRouter().onGenerateRoute,
              );
            })));
  }
}
