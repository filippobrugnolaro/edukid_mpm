abstract class AuthRepository {

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required int points,
  });

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

}