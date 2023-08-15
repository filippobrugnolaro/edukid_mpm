import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edukid/features/authentication/presentation/pages/signup.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_colors.orange,
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GetStartedPage()));
          } else if (state is AuthError) {
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.all(20),
                    title: Text('Error', style: TextStyle(fontSize: 14.sp)),
                    content: Text(state.error.replaceFirst('Exception: ', ''),
                        style: TextStyle(fontSize: 13.sp)),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: app_colors.orange),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok', style: TextStyle(fontSize: 13.sp))),
                    ],
                  );
                },
              );
            });
          }
        }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Loading) {
            // Showing the loading indicator while the user is signing in
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(app_colors.orange),
            ));
          }
          if (state is UnAuthenticated) {
            // Showing the sign in form if the user is not authenticated
            return Stack(fit: StackFit.expand, children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/doodle.png'),
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
                      margin: EdgeInsets.fromLTRB(15.0.w, 5.h, 15.w, 0.h),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              child: Text(
                                'Login to your existing account',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            SizedBox(height: 2.0.h),
                            emailField(context),
                            SizedBox(height: 3.0.h),
                            passwordField(context),
                            SizedBox(height: 3.0.h),
                            Align(
                              child: getLoginButton(),
                            ),
                            SizedBox(height: 3.0.h),
                            const Divider(
                              color: app_colors.grey,
                            ),
                            SizedBox(height: 3.0.h),
                            Align(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  'Do not have an account yet?\nSignup now!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )))
            ]);
          }
          return const Center(
            child: Text('An error occurred, try again!'),
          );
        })));
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
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
          return value != null && value.isEmpty
              ? 'Please insert your password.'
              : null;
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
                ? 'Please insert a valid email address.'
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

  Widget getLoginButton() {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(4.w,1.3.h,4.w,1.3.h)),
        backgroundColor: MaterialStateProperty.all<Color>(
            app_colors.orange), // Set the background color
      ),
      child: Text("Login",
          style: TextStyle(fontSize: 13.0.sp, color: app_colors.white)),
      onPressed: () {
        _authenticateWithEmailAndPassword(context);
      },
    );
  }
}
