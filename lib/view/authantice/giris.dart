import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_flutter/utils/signInhelper.dart';
import 'package:firebase_flutter/view/authantice/anasayfa_view.dart';
import 'package:firebase_flutter/view/authantice/register.dart';
import 'package:firebase_flutter/widgets/appbar.dart';
import 'package:firebase_flutter/widgets/ext_floating.dart';
import 'package:firebase_flutter/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class GirisView extends StatefulWidget {
  GirisView({Key key}) : super(key: key);

  @override
  _GirisViewState createState() => _GirisViewState();
}

class _GirisViewState extends State<GirisView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var formkey = GlobalKey<FormState>();
  var formKeyEmail = GlobalKey<FormState>();
  var formKeyPassword = GlobalKey<FormState>();
  var emaill = TextEditingController();
  var passwordd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarView("Giris Yap"),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    TextInputWidget("Lütfen E-mailinizi giriniz", emaill, false,
                        validatoremail),
                    TextInputWidget("Şifrenizi Giriniz", passwordd, true,
                        validatorpassword),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ExtendedFloatingBtn("kayıtolll", onpressKayitOl, "Kayıt Ol"),
                ExtendedFloatingBtn("girisYappp", onpressGiris, "Giriş Yap"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.grey.shade300,
                  onPressed: () async {
                    var data = await SignInHelper.instance().signIn();
                    if (data != null) {
                      var userData =
                          await SignInHelper.instance().firebaseSignIn();
                      print("signed in " + userData.displayName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnasayfaView(
                              userData.email,
                              userData.displayName,
                              userData.photoUrl,
                              userData.uid),
                        ),
                      );
                    }
                  },
                  child: Image(
                    width: 40,
                    image: NetworkImage(
                        "https://i0.wp.com/nanophorm.com/wp-content/uploads/2018/04/google-logo-icon-PNG-Transparent-Background.png?fit=1000%2C1000&ssl=1"),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "twitter",
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    var twitterData =
                        await SignInHelper.instance().twitterSignIn();
                    if (twitterData != null) {
                      var userData =
                          await SignInHelper.instance().twitterFirebaseSignIn();
                      debugPrint("Kullanıcının adı : " + userData.displayName);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AnasayfaView(userData.email, userData.displayName ,userData.photoUrl, userData.uid)));
                    }
                  },
                  child: Icon(
                    FontAwesome.twitter,
                    size: 38,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  onpressGiris() async {
    formkey.currentState.validate();

    auth
        .signInWithEmailAndPassword(
            email: emaill.text, password: passwordd.text)
        .then((oturumAcmisKullanici) {
      var signUser = oturumAcmisKullanici.user;
      if (signUser.isEmailVerified) {
        debugPrint("Email onaylı kullanıcı giriş yapılıyor");
        debugPrint("uid : ${signUser.uid}");
      } else {
        debugPrint(
            "Emailinize aktivasyon postası gönderdik lütfen onaylayınız");
        signUser.sendEmailVerification();
        auth.signOut();
      }
    }).catchError(
      (signInError) => debugPrint("E-mail yada şifre hatalı"),
    );
  }

  onpressKayitOl() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  String validatoremail(String email) {
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

  String validatorpassword(String validpass) {
    if (validpass.length <= 6) {
      debugPrint("BURAYA GİRDİ");
      return "Lüften parolanızı 6'dan büyük karakter olacak şekilde giriş yapın";
    } else {
      return null;
    }
  }
}
