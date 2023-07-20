import 'dart:math';

import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/di_container.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
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

  String name = '';
  String surname = '';
  String email = '';
  int points = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final personalData = await sl<ProfileRepository>().getUserData(); // Chiedere ad ale
      setState(() {
        email = personalData.email;
        name = personalData.name;
        surname = personalData.surname;
        points = personalData.points;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_colors.orange,
        title: const Text('Your profile'),
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/avatars/$randomLetter.png',
                  width: 35.w,
                  height: 35.h,
                ),
                Text(
                  'Name: $name',
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Surname: $surname',
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Points: $points',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
