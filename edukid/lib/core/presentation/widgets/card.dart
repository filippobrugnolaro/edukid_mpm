import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color borderColor;
  final String goTo;
  //final VoidCallback onPressed;

  const CardWidget({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.borderColor,
    required this.goTo,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 35.w,
        height: 20.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(app_colors.white),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(16.0)), // Set the desired padding
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
                color: borderColor, width: 3.0)), // Set the desired border
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    15.0), // Set the desired border radius
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(goTo);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                imagePath,
                width: 25.w,
                height: 12.h,
              ),
              Builder(
                builder: (BuildContext context) {
                  // Create a MediaQuery with a custom textScaleFactor
                  final customMediaQuery = MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0, // Adjust the text scale factor as needed
                  );
                  return MediaQuery(
                    data: customMediaQuery,
                    child: Expanded(
                      child: Text(
                        text,
                        style: TextStyle(color: app_colors.black, fontSize: 12.5.sp),
                      ),
                    )
                  );
                },
              )
            ],
          ),
        ));
  }
}
