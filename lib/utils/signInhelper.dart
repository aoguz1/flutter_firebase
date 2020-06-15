import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/keys/twitterkey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter/flutter_twitter.dart';


class SignInHelper {
  static SignInHelper _googleSignInHelper = SignInHelper._private();

  SignInHelper._private();

  static SignInHelper instance() {
    return _googleSignInHelper;
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<GoogleSignInAccount> signIn() async {
    var user = await _googleSignIn.signIn();
    if (user != null) {
      print(user.email);
      return user;
    } else {
      return null;
    }
  }

  Future<GoogleSignInAuthentication> googleAuthententice() async {
    if (await _googleSignIn.isSignedIn()) {
      var user = _googleSignIn.currentUser;
      final userData = user.authentication;
      return userData;
    }
  }

  Future<GoogleSignInAccount> signOut() async {
    var user = await _googleSignIn.signOut();
    if (user != null) {
      print(user.email);
      return user;
    } else {
      return null;
    }
  }

  Future<FirebaseUser> firebaseSignIn() async {
    final GoogleSignInAuthentication googleUser = await googleAuthententice();
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleUser.idToken, accessToken: googleUser.accessToken);

    final user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  twitterSignIn() async {
    var twitterLoginKeys = TwitterLogin(
        consumerKey: TwitterKey.twitterKey,
        consumerSecret: TwitterKey.twittersecretKey);

    TwitterLoginResult twitterAuth = await twitterLoginKeys.authorize();

    if (twitterAuth.status == TwitterLoginStatus.loggedIn) {
      var sesion = twitterAuth.session;
      var credantial = TwitterAuthProvider.getCredential(
          authToken: sesion.token, authTokenSecret: sesion.secret);

      return credantial;
    } else if (twitterAuth.status == TwitterLoginStatus.cancelledByUser) {
      debugPrint("Giriş yapılırken kullanıcı iptali ");
    } else {
      debugPrint("Hata çıktı");
    }
  }

  Future<FirebaseUser> twitterFirebaseSignIn() async {
    var twitterUser =await twitterSignIn(); // signIn olmuş kullanıcıyı burada alıyoruz.
    var twitterFireUser = (await _auth.signInWithCredential(twitterUser))
        .user; //kullanıcı verileri ile firebase'e giriş yaptığımız yer

    return twitterFireUser;
  }
}
