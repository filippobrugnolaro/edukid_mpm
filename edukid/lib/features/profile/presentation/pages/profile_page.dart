import 'dart:math';

import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/widgets/menuDrawer.dart';
import 'package:edukid/di_container.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// final or const?
const letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];

final random = Random();
final randomIndex = random.nextInt(letters.length);
final randomLetter = letters[randomIndex];

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileRepository = sl<ProfileRepository>();
  String name = '';
  String surname = '';
  String email = '';
  int points = 0;
  bool isLoaded = false;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    if(await profileRepository.isDeviceConnected()) {
      final personalData = await profileRepository.getUserData();
      setState(() {
        email = personalData.email;
        name = personalData.name;
        surname = personalData.surname;
        points = personalData.points;
        isLoaded = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your profile'),
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
        pageNumber: 1,
      ),
      body: isLoaded ? Stack(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/avatars/$randomLetter.png',
                  width: 35.w,
                  height: 35.h,
                ),
                Text(
                  '$name $surname',
                  style: TextStyle(
                      color: app_colors.black,
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3.h),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Email: ',
                        style:
                            TextStyle(
                              fontSize: 13.sp, 
                              fontFamily: 'Poppins', 
                              color: app_colors.black),
                      ),
                      TextSpan(
                        text: email,
                        style: TextStyle(
                          color: app_colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Points: ',
                        style:
                            TextStyle(
                              color: app_colors.black,
                              fontSize: 13.sp, 
                              fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: '$points',
                        style: TextStyle(
                            color: app_colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: app_colors.orange,
                        padding: EdgeInsets.all(2.h)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return getDialog(context);
                          });
                    },
                    child: Text('Log out', style: TextStyle(fontSize: 13.sp)))
              ],
            ),
          )
        ],
      ) :
      Stack(
          fit: StackFit.expand,
          children: [
      const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(app_colors.orange),)),
        if(!isConnected)
          AlertDialog(
            actionsPadding: const EdgeInsets.all(20),
            title: const Text('Error'),
            content: const Text('It seems there is no internet connection. Please connect to a wifi or mobile data network.'),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
                  onPressed: () {
                    Navigator.pushNamed(context, "profile");
                    if(isConnected) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ok')),
      ],
    ),
    ],
      ),
    );
  }

  Widget getDialog(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text('Confirm logout'),
      content: const Text('Are you sure you want to logout?'),
      actionsPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Background color
              foregroundColor: Colors.black, // Text color
              side: const BorderSide(color: app_colors.orange, width: 2),
            ),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignOutRequested(),
              );
              Navigator.of(context).pushReplacementNamed("login");
            },
            child: const Text('Yes')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No')),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
