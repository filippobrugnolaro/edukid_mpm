import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_colors.orange,
          title: Text('Accedi'),
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
          Center(
            child: Form(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin:
                    (MediaQuery.of(context).orientation == Orientation.portrait
                        ? (SizerUtil.deviceType == DeviceType.mobile
                            ? EdgeInsets.fromLTRB(8.0.w, 5.0.h, 8.0.w, 0.0.h)
                            : EdgeInsets.fromLTRB(15.0.w, 5.0.h, 15.0.w, 0.0.h))
                        : EdgeInsets.fromLTRB(40.0.w, 5.0.h, 40.0.w, 0.0.h)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Accedi al tuo account',
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 2.0.h),
                    getEmailInput(context),
                    SizedBox(height: 3.0.h),
                    getPasswordInput(context),
                    SizedBox(height: 3.0.h),
                    Align(
                      child: getLoginButton(),
                    ),
                    SizedBox(height: 2.0.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Se non hai ancora un account ',
                        children: <TextSpan>[
                          TextSpan(
                            text: 'registrati',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                    Divider(
                      color: const Color.fromARGB(255, 220, 220, 220),
                      thickness: 1,
                    ),
                    SizedBox(height: 2.0.h),
                    GestureDetector(
                      onTap: () {
                        _showDialog(context);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                '/images/google.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 2.w,),
                            Text('Accedi con google')
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  Widget getEmailInput(dynamic context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: app_colors.orange, // Set your desired cursor color
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: app_colors.orange), // Set your desired border color
          ),
        ),
      ),
      child: TextField(
        style: TextStyle(
            fontSize:
                (SizerUtil.deviceType == DeviceType.mobile ? 12.0.sp : 2.0.h)),
        onChanged: (email) => {},
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: app_colors.white, // Set your desired background color
            labelText: 'Email',
            errorStyle: TextStyle(
                fontSize: (SizerUtil.deviceType == DeviceType.mobile
                    ? 10.0.sp
                    : 1.5.h)),
            contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 6),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: app_colors.orange),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            )),
      ),
    );
  }

  Widget getPasswordInput(dynamic context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: app_colors.orange, // Set your desired cursor color
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: app_colors.orange), // Set your desired border color
          ),
        ),
      ),
      child: TextField(
        obscureText: true,
        style: TextStyle(
            fontSize:
                (SizerUtil.deviceType == DeviceType.mobile ? 12.0.sp : 2.0.h)),
        onChanged: (password) => {},
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: app_colors.white, // Set your desired background color
            labelText: 'Password',
            errorStyle: TextStyle(
              fontSize: (10.0.sp),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 6),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: app_colors.orange),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            )),
      ),
    );
  }

  Widget getLoginButton() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              app_colors.orange), // Set the background color
        ),
        child: Text("Accedi",
            style: TextStyle(fontSize: 9.0.sp, color: app_colors.white)),
        onPressed: () {});
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prova'),
          content: Text('Prova per vedere che sia clickable. Poi in realtà faremo chiamata al backend per fare autenticazione'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }
}
