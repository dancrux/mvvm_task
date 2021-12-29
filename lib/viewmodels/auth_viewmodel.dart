import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/db/shared_prefs_db.dart';
import 'package:mvvm_task/view/customWidgets/custom.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  uninitialized,
  initialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthViewModel extends ChangeNotifier {
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth;
  AuthStatus _authStatus = AuthStatus.uninitialized;

  AuthStatus get authStatus => _authStatus;

  User? _user;
  User? get user => _user;

  AuthViewModel.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen(onAuthStateChanged);
  }

  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _authStatus = AuthStatus.unauthenticated;
    } else {
      _authStatus = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _authStatus = AuthStatus.authenticating;
      notifyListeners();
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await user?.reload();
      _user = _firebaseAuth.currentUser;
      SharedPrefsUtil.instance.saveEmail(email);
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Email does not match an existing account'));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(content: 'Password is incorrect'));
      }
    }
    return user;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        _user = userCredential.user;
        var email = _user?.email ?? "Anonymous";

        SharedPrefsUtil.instance.saveEmail(email);

        _authStatus = AuthStatus.authenticated;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        _authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        switch (e.code) {
          case 'account-exists-with-different-credential':
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content:
                    'Account Mismatch please cross check, or retry with a different account'));
            break;
          case 'invalid-credential':
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content:
                    'Could not sign in with selected account, try a different account'));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                content: 'An Unknown Error Occured while processing'));
        }
      } catch (e) {
        _authStatus = AuthStatus.unauthenticated;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            content: 'Could not p roceed with sign in please retry'));
      }
    }
    return user;
  }
}
