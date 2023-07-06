/*import 'package:edukid/features/trivia/data/repositories/auth/bloc/auth_bloc.dart';
import 'package:edukid/features/trivia/presentation/screens/login/bloc/login_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

bool _loginInProgress = false;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) =>
          LoginBloc(authenticationBloc: context.read<AuthBloc>()),
      child: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_colors.orange,
          title: Text('Accedi'),
        ),
        body: SingleChildScrollView(
          child: getLoginForm(context),
        ));

    /*body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          getLoginForm(context)
        ]));*/
  }

  Widget getLoginForm(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.status.isSubmissionInProgress) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Form(
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
                    'Accedi al tuo account',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
                SizedBox(height: 2.0.h),
                getEmailInput(context),
                SizedBox(height: 3.0.h),
                //getPasswordInput(context),
                SizedBox(height: 3.0.h),
                Align(
                  child: getLoginButton(),
                ),
                SizedBox(height: 3.0.h),
                Align(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 10.sp),
                      text: 'Se non hai ancora un account ',
                      children: <TextSpan>[
                        TextSpan(
                          text: 'registrati',
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: app_colors
                                  .orange // Customize the color as desired
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showDialog(context);
                            },
                        ),
                      ],
                    ),
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
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Accedi con google',
                          style: TextStyle(fontSize: 10.sp),
                        )
                      ]),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  Widget getEmailInput(dynamic context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => (previous.email != current.email),
        builder: (context, state) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: app_colors.orange, // Set your desired cursor color
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          app_colors.orange), // Set your desired border color
                ),
              ),
            ),
            child: TextField(
              style: TextStyle(
                  fontSize: (SizerUtil.deviceType == DeviceType.mobile
                      ? 12.0.sp
                      : 2.0.h)),
              onChanged: (email) =>
                  context.read<LoginBloc>().add(EmailChanged(email)),
              decoration: InputDecoration(
                  errorText: state.email.invalid ? 'Invalid email' : null,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor:
                      app_colors.white, // Set your desired background color
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
        });
  }

  Widget getPasswordInput(dynamic context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            (previous.password != current.password),
        builder: (context, state) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: app_colors.orange, // Set your desired cursor color
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          app_colors.orange), // Set your desired border color
                ),
              ),
            ),
            child: TextField(
              obscureText: true,
              style: TextStyle(
                  fontSize: (SizerUtil.deviceType == DeviceType.mobile
                      ? 12.0.sp
                      : 2.0.h)),
              onChanged: (password) =>
                  context.read<LoginBloc>().add(PasswordChanged(password)),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor:
                      app_colors.white, // Set your desired background color
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
        });
  }

  Widget getLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  app_colors.orange), // Set the background color
            ),
            child: Text("Accedi",
                style: TextStyle(fontSize: 8.0.sp, color: app_colors.white)),
            onPressed: state.status.isValidated &&
                    !state.status.isSubmissionInProgress &&
                    !state.status.isSubmissionSuccess
                ? () {
                    _loginInProgress = true;
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.read<LoginBloc>().add(const Submitted());
                  }
                : null,
          );
        });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Prova'),
          content: const Text(
              'Prova per vedere che sia clickable. Poi in realtà faremo chiamata al backend per fare autenticazione'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  void showProgressDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}*/

import 'package:edukid/features/trivia/data/bloc/auth_bloc.dart';
import 'package:edukid/features/trivia/presentation/screens/getStarted/getStarted.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

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
          title: Text('Accedi'),
        ),
        body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const GetStarted()));
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
                          'Accedi al tuo account',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Oppure accedi con Google'),
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
            ? 'Non è un valido indirizzo mail!'
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
      child: Text("Accedi",
          style: TextStyle(fontSize: 8.0.sp, color: app_colors.white)),
      onPressed: () {
        _authenticateWithEmailAndPassword(
            context);
      },
    );
  }

}
