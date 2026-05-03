import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return 'Email or password is incorrect';
        case 'user-disabled':
          return 'This user has been BANNED!';
        case 'invalid-email':
          return 'Please enter a valid email address';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already in use, please use a different email';
        case 'invalid-email':
          return 'Please enter a valid email address';
        case 'weak-password':
          return 'Your password must be at least 6 characters long';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Sign in cancelled';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Google sign in failed';
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<String?> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Guest sign in failed';
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Please enter a valid email address';
        case 'user-not-found':
          return 'No account found with that email';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
}
