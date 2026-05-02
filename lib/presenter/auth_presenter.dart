import 'package:firebase_auth/firebase_auth.dart';
import '../model/auth_model.dart';

class AuthPresenter {
  final AuthModel _model = AuthModel();

  Future<String?> login(String email, String password) {
    return _model.login(email, password);
  }

  Future<String?> signUp(
    String email,
    String password,
  ) {
    return _model.signUp(email, password);
  }

  Future<void> logout() {
    return _model.signOut();
  }

  Stream authStateChanges() {
    return _model.authStateChanges();
  }

  String? getCurrentUserEmail() {
    return _model.currentUser?.email;
  }

//Disabling for now will implement next

  // Future<String?> sendPasswordResetEmail(String email) {
  //   return _model.sendPasswordResetEmail(email);
  // }

  Future<String?> signInWithGoogle() {
    return _model.signInWithGoogle();
  }

  User? get currentUser => _model.currentUser;
}