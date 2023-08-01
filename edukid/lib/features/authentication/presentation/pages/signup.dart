import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

final DateTime selectedDate = DateTime.now();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_colors.orange,
          title: Text('Signup'),
        ),
        body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => GetStartedPage()));
          }
        }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Loading) {
            // Showing the loading indicator while the user is signing in
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(app_colors.orange),)
            );
          }
          if (state is UnAuthenticated) {
            // Showing the sign in form if the user is not authenticated
            return Stack(fit: StackFit.expand, children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/doodle.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: (MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? (SizerUtil.deviceType == DeviceType.mobile
                              ? EdgeInsets.fromLTRB(8.0.w, 5.0.h, 8.0.w, 0.0.h)
                              : EdgeInsets.fromLTRB(
                                  15.0.w, 5.0.h, 15.0.w, 0.0.h))
                          : EdgeInsets.fromLTRB(20.0.w, 5.0.h, 20.0.w, 0.0.h)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            child: Text(
                              'Create a new account!',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SizedBox(height: 2.0.h),
                          nameField(context),
                          SizedBox(height: 3.0.h),
                          surnameField(context),
                          SizedBox(height: 3.0.h),
                          emailField(context),
                          SizedBox(height: 3.0.h),
                          passwordField(context),
                          SizedBox(height: 3.0.h),
                          Align(
                            child: getSignupButton(),
                          ),
                        ],
                      )))
            ]);
          }
          return Container();
        })));
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_emailController.text, _passwordController.text,
            _nameController.text, _surnameController.text, 0),
      );
    }
  }

  Widget getSignupButton() {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(2.h)),
        backgroundColor: MaterialStateProperty.all<Color>(
            app_colors.orange), // Set the background color
      ),
      child: Text("Signup",
          style: TextStyle(fontSize: 13.0.sp, color: app_colors.white)),
      onPressed: () {
        _createAccountWithEmailAndPassword(context);
      },
    );
  }

  Widget passwordField(context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: app_colors.orange, // Set your desired cursor color
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: app_colors.orange), // Set your desired border color
          ),
        ),
      ),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        controller: _passwordController,
        decoration: InputDecoration(
            hintText: "Password",
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please insert your password.';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters.';
          }
          return null; // Return null to indicate no error
        },
      ),
    );
  }

  Widget emailField(context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: app_colors.orange, // Set your desired cursor color
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: app_colors.orange), // Set your desired border color
            ),
          ),
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value != null && !EmailValidator.validate(value)
                ? 'Please insert a valid email!'
                : null;
          },
          decoration: InputDecoration(
              hintText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: app_colors.white, // Set your desired background color
              labelText: 'Email',
              errorStyle: TextStyle(
                fontSize: (10.0.sp),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 6),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: app_colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              )),
        ));
  }

  Widget nameField(context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: app_colors.orange, // Set your desired cursor color
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: app_colors.orange), // Set your desired border color
            ),
          ),
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value != null && value.isEmpty
                ? 'Please insert your name.'
                : null;
          },
          decoration: InputDecoration(
              hintText: "Name",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: app_colors.white, // Set your desired background color
              labelText: 'Name',
              errorStyle: TextStyle(
                fontSize: (10.0.sp),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 6),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: app_colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              )),
        ));
  }

  Widget surnameField(context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: app_colors.orange, // Set your desired cursor color
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: app_colors.orange), // Set your desired border color
            ),
          ),
        ),
        child: TextFormField(
          controller: _surnameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return value != null && value.isEmpty
                ? 'Please insert your surname.'
                : null;
          },
          decoration: InputDecoration(
              hintText: "Surname",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: app_colors.white, // Set your desired background color
              labelText: 'Surname',
              errorStyle: TextStyle(
                fontSize: (10.0.sp),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 6),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: app_colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              )),
        ));
  }
}
