import 'package:edukid/core/presentation/widgets/custom_text.dart';
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../config/colors.dart' as app_colors;

class MenuDrawer extends StatelessWidget {
  final int pageNumber;

  const MenuDrawer({Key? key, required this.pageNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80.w,
        child: Drawer(
            child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _buildMenuItem(
                      text: 'Home',
                      icon: Icons.home,
                      onClicked: () {
                        _selectedItem(context, 0);
                      },
                      isAlreadyIn: pageNumber == 0 ? true : false,
                    ),
                    _buildMenuItem(
                      text: 'My profile',
                      icon: Icons.account_box,
                      onClicked: () {
                        _selectedItem(context, 1);
                      },
                      isAlreadyIn: pageNumber == 1 ? true : false,
                    ),
                    _buildMenuItem(
                      text: 'Statistics',
                      icon: Icons.graphic_eq_rounded,
                      onClicked: () {
                        _selectedItem(context, 2);
                      },
                      isAlreadyIn: pageNumber == 2 ? true : false,
                    ),
                    _buildMenuItem(
                      text: 'How to play',
                      icon: Icons.question_mark_outlined,
                      onClicked: () {
                        _selectedItem(context, 3);
                      },
                      isAlreadyIn: pageNumber == 3 ? true : false,
                    ),
                    _buildMenuItem(
                      text: 'Logout',
                      icon: Icons.directions_run_sharp,
                      onClicked: () {
                        _selectedItem(context, 4);
                      },
                      isAlreadyIn: pageNumber == 4 ? true : false,
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    required VoidCallback? onClicked,
    required bool isAlreadyIn,
  }) {
    return ListTile(
        tileColor: isAlreadyIn ? const Color.fromARGB(255, 239, 239, 239) : null,
        leading: Icon(
          icon,
          size: 3.0.h,
          color: isAlreadyIn ? app_colors.orange : app_colors.black,
        ),
        title: CustomText(text, 12.0.sp, 12.0.sp,
            color: isAlreadyIn ? app_colors.orange : app_colors.black),
        onTap: onClicked);
  }

  void _selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    if (pageNumber != index) {
      switch (index) {
        case 0:
          {
            Navigator.of(context).pushNamed("getStarted");
          }
          break;
        case 1:
          {
            Navigator.of(context).pushNamed("profile");
          }
          break;
        case 2:
          {
            Navigator.of(context).pushNamed("statistics");
          }
          break;
        case 3:
          {
            Navigator.of(context).pushNamed("howtoplay");
          }
          break;
        case 4:
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return getDialog(context);
              });
          }
          break;
      }
    }
  }

  Widget getDialog(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title:  Text('Confirm logout', style: TextStyle(fontSize: 14.sp)),
      content:  Text('Are you sure you want to logout?', style: TextStyle(fontSize: 13.sp)),
      actionsPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(4.w,1.3.h,4.w,1.3.h),
            backgroundColor: Colors.white, // Background color
            foregroundColor: Colors.black, // Text color
            side: const BorderSide(color: app_colors.orange, width: 2),),
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(
              SignOutRequested(),
            );
            Navigator.of(context).pushReplacementNamed("login");
          },
          child: Text('Yes', style: TextStyle(fontSize: 13.sp))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange,padding: EdgeInsets.fromLTRB(4.w,1.3.h,4.w,1.3.h)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No', style: TextStyle(fontSize: 13.sp))),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
