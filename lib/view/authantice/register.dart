

import 'package:firebase_flutter/view/authantice/forgot_password.dart';
import 'package:firebase_flutter/widgets/appbar.dart';
import 'package:firebase_flutter/widgets/ext_floating.dart';

import 'package:firebase_flutter/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarView("Kayıt Ol"),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextInputWidget("Lütfen E-mailinizi giriniz", email,
                            false, emailvalid),
                        TextInputWidget(
                            "Şifrenizi giriniz", pass, true, passvalid),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ExtendedFloatingBtn("sifreunut",
                                onpressForgotPassword, "Şifremi Unuttum"),
                            ExtendedFloatingBtn(
                                "kayıttt", onPressRegister, "Kayıt Ol"),
                          ],
                        )
                      ],
                    )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  onpressForgotPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPass()));
  }

  String emailvalid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email)) {
      //regex içinde olan değerler olmadığında içeri girip ifadeyi return olarak döndürür.
      return "Geçersiz e-mail";
    } else {
      return null;
    }
  }

  String passvalid(String valid) {
    if (valid.length <= 6) {
      return "Lütfen 6 karakterden fazla değer giriniz";
    } else {
      return null;
    }
  }

  onPressRegister() async {
    formKey.currentState.validate();
    var authResult = await auth
        .createUserWithEmailAndPassword(email: email.text, password: pass.text)
        .catchError((err) => debugPrint("Hata oluştu hata kodu : $err"));

    var firebaseUser = authResult.user;

    if (firebaseUser != null) {
      firebaseUser.sendEmailVerification().then((value) {
        auth.signOut();
        debugPrint(
            "E-mailinize aktivasyon e-postası gönderdik lütfen onaylayın");
      }).catchError((err) => debugPrint("Aktivasyon gönderirken hata çıktı"));
    } else {
      debugPrint("Bu e-mail kullanımda");
    }
  }
}
