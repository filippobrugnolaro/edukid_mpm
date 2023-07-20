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
          title: Text('Login'),
        ),
        body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => GetStartedPage()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Loading) {
            // Showing the loading indicator while the user is signing in
            return const Center(
              child: CircularProgressIndicator(),
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
                  margin: (MediaQuery.of(context).orientation == Orientation.portrait
                      ? (SizerUtil.deviceType == DeviceType.mobile
                          ? EdgeInsets.fromLTRB(8.0.w, 5.0.h, 8.0.w, 0.0.h)
                          : EdgeInsets.fromLTRB(15.0.w, 5.0.h, 15.0.w, 0.0.h))
                      : EdgeInsets.fromLTRB(20.0.w, 5.0.h, 20.0.w, 0.0.h)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        child: Text(
                          'Login to your existing account',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                      SizedBox(height: 2.0.h),
                      emailField(context),
                      SizedBox(height: 3.0.h),
                      passwordField(context),
                      SizedBox(height: 3.0.h),
                      Align(
                        child: getLoginButton(),),
                      SizedBox(height: 3.0.h),
                      Divider(),
                      SizedBox(height: 3.0.h),
                      Align(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Do not have an account yet? Signup now!',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.0.h),
                      Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Or login with Google'),
                            IconButton(
                            onPressed: () {
                              _authenticateWithGoogle(context);
                            },
                            icon: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          ]
                        ),
                      ),
                      ],

            )))]);
          }
          return Container();
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

//
  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
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
      ),
    );
  }

  Widget emailField(context){
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
      autovalidateMode:
          AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value != null &&
                !EmailValidator.validate(value)
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
              fontSize: (8.0.sp),
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
        backgroundColor: MaterialStateProperty.all<Color>(
            app_colors.orange), // Set the background color
      ),
      child: Text("Login",
          style: TextStyle(fontSize: 8.0.sp, color: app_colors.white)),
      onPressed: () {
        _authenticateWithEmailAndPassword(
            context);
      },
    );
  }

}
