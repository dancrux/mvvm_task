import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/view/customWidgets/custom.dart';

enum AuthStatus {
  uninitialized,
  initialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthViewModel extends ChangeNotifier {
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
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await user?.reload();
      _user = _firebaseAuth.currentUser;
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
}
