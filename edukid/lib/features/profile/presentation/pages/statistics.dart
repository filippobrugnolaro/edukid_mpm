import 'package:edukid/di_container.dart';
import 'package:edukid/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:sizer/sizer.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
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
    final personalData =
        await sl<ProfileRepository>().getUserData(); // Chiedere ad ale
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
          title: const Text('Statistics'),
        ),
        body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: app_colors.transparent,
                      border: Border.all(color: app_colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LEADERBOARD',style: TextStyle(
                                  fontSize: 3.h, fontWeight: FontWeight.bold)),
                                  SizedBox(height:2.h),
                        _buildPodiumEntry(1, name, surname, points),
                        SizedBox(height: 2.h),
                        _buildPodiumEntry(2, "a", "a", 10),
                        SizedBox(height: 2.h),
                        _buildPodiumEntry(3, "b", "b", 7),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your points: $points',
                          style: TextStyle(fontSize: 10.sp)),
                      Text(
                        'Your position in the ranking: x',
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ))
        ]));
  }

  Widget _buildPodiumEntry(
      int rank, String firstName, String lastName, int points) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: app_colors.white,
                      border: Border.all(color: app_colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$rank.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3.h),
              ),
              SizedBox(width: 2.w),
              Text(
                '$firstName $lastName', style: TextStyle(fontSize: 2.5.h)
              ),
            ],
          ),
          Expanded(
            // Use Expanded to align the icon and points to the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$points',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 2.w),
                Image.asset(
                  'images/coin.png',
                  height: 3.5.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
