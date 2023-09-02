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
      if (e.message!.contains('email-already-in-use')) {
        throw Exception(
            'Questo indirizzo email è già in uso da un altro account.');
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
            'Utente non trovato. Perfavore controlla la tua email o crea un nuovo account.');
      }
      if (e.message!.contains('wrong-password') ||
          e.message!.contains('password is invalid')) {
        throw Exception(
            'La password inserita non è corretta. Perfavore controlla la tua password e riprova.');
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
