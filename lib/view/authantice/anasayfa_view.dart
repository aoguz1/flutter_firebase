import 'package:firebase_flutter/utils/signInhelper.dart';
import 'package:firebase_flutter/widgets/giris_text.dart';
import 'package:flutter/material.dart';

import 'package:firebase_flutter/widgets/appbar.dart';

class AnasayfaView extends StatelessWidget {
  String email;
  String userName;
  String photoUrl;
  String uid;

  AnasayfaView(
    this.email,
    this.userName,
    this.photoUrl,
    this.uid,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarView(userName),
      body: Container(
        color: Colors.teal,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 5,
              top: 150,
              height: MediaQuery.of(context).size.height * 0.24,
              width: MediaQuery.of(context).size.width* 0.966,
              child: Card(
                elevation: 14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GirisTextWidget("Isim : ", userName.toString()),
                    GirisTextWidget("Kullanıcının E-Maili : ", email.toString()),
                    GirisTextWidget("UID : ", uid),
                    
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color: Colors.red.shade700,
                        onPressed: () async {
                        
                          print(userName +
                              " uygulamadan çıkış yapıyor");
                          SignInHelper.instance().signOut();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Çıkış Yap",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
            Align(
              alignment:
                  Alignment.lerp(Alignment(0, -0.72), Alignment(0, 0), 0),
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(photoUrl),
              ),
            )
          ],
        ),
      ),
    );
  }
}
