import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSourceRemote {
  Future<void> signUp({required String email, required String password});

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  String getSignedUpUserUID();

  String getSignedInUserUID();

  bool isSignedUpUserNull();

  bool isSignedInUserNull();
}

class AuthDataSourceRemoteImpl implements AuthDataSourceRemote {
  final _firebaseAuth = FirebaseAuth.instance;
  User? signedUpUser;

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
        final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;
        if (user != null) {
          signedUpUser = user;
        }
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains('weak-password')) {
        throw Exception('Password should be at least 6 characters!');
      }
      if (e.message!.contains('email-already-in-use')) {
        throw Exception(
            'This email address is already in use by another account.');
      } else {
        throw Exception(e.toString().replaceFirst('[firebase_auth/email-already-in-use] ',''));
      }
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains('user-not-found') ||
          e.message!.contains('no user record')) {
        throw Exception(
            'User not found. Please check your email or create a new account.');
      }
      if (e.message!.contains('wrong-password') ||
          e.message!.contains('password is invalid')) {
        throw Exception(
            'The password is invalid. Please check your password and try again');
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      signedUpUser = null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  String getSignedUpUserUID() {
    return signedUpUser!.uid;
  }

  @override
  String getSignedInUserUID() {
    return _firebaseAuth.currentUser!.uid;
  }

  @override
  bool isSignedUpUserNull() {
    return signedUpUser == null;
  }

  @override
  bool isSignedInUserNull() {
    return _firebaseAuth.currentUser == null;
  }
}
