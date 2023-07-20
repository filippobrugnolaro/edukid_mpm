import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthDataSource {

  Future<void> signInWithGoogle();

  Future<void> signUp({
    required String email,
    required String password
  });

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

class AuthDataSourceImpl implements AuthDataSource {

  final _firebaseAuth = FirebaseAuth.instance;
  User? signedUpUser;

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password
  }) async {
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
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
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
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
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