import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;
import 'package:flutter/material.dart';

final letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];
  
  final random = Random();
  final randomIndex = random.nextInt(letters.length);
  final randomLetter = letters[randomIndex];


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final userRef = FirebaseDatabase.instance.ref().child('users');

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
    final userDataSnapshot = await userRef.child(user.uid).once();
    if (userDataSnapshot.snapshot.value != null) {
      final userData = userDataSnapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = userData['name'] ?? '';
        surname = userData['surname'] ?? '';
        email = user.email ?? '';
        points = userData['points'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_colors.orange,
        title: Text('Your profile'),
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
                  'Name: $name $surname',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Points: $points',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
