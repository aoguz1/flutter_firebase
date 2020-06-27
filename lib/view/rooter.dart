import 'package:firebase_flutter/view/authantice/giris.dart';
import 'package:firebase_flutter/view/cloud_firestore/firetore.dart';
import 'package:flutter/material.dart';

class RooterView extends StatelessWidget {
  const RooterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
          RaisedButton(
              color: Colors.amber,
              child: Text("Giriş Yap"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GirisView()));
              }),
          RaisedButton(
              color: Colors.green.shade400,
              child: Text("Firetore"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirestoreView()));
              })
        ],
      ),
    );
  }
}
