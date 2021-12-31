import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  //  Test for sign in with google
  late MockGoogleSignIn googleSignIn;
  setUp(() {
    googleSignIn = MockGoogleSignIn();
  });

  test('if udToken and access token is returned during authentication',
      () async {
    final signInAccount = await googleSignIn.signIn();
    final signInAuthentication = await signInAccount!.authentication;

    expect(signInAuthentication, isNotNull);
    expect(signInAuthentication.accessToken, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);
  });
  // test google login is succesful
  test('should not return null when google login is Succesful ', () async {
    googleSignIn.setIsCancelled(false);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNotNull);
  });
}
