import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreView extends StatefulWidget {
  @override
  _FirestoreViewState createState() => _FirestoreViewState();
}

class _FirestoreViewState extends State<FirestoreView> {
  final Firestore _firestore = Firestore.instance;

  File secilenresim;

  void veriEkle() {
    Map<String, dynamic> aoguzVeri = Map();
    aoguzVeri['ad'] = "abdullah";
    aoguzVeri["soyad"] = "oguz";
    aoguzVeri["erkek mi ? "] = true;
    _firestore
        .collection("users")
        .document("abdullah")
        .setData(aoguzVeri)
        .then((value) => debugPrint("abdullah eklendi"));

    _firestore.collection("users").document("hasan").setData(
        {'ad': 'hasan', 'okul': 'paü', 'bölüm': 'ybs'}).whenComplete(() {
      debugPrint("hasan eklendi");
    });

    // direkt dokuman üzerinden ulaşma
    _firestore
        .document("/users/ayse")
        .setData({'ad': 'ayse'}); // direkt collection olarak ekleme yapma.

    _firestore.collection("users").add({'ad': 'can', 'yas': 19});

    String newUserId = _firestore.collection("users").document().documentID;
    print(newUserId);

    _firestore.collection("users").document(newUserId).setData({
      'userID': '$newUserId',
      'name': 'mustafa',
      'okul': 'ege üniversitesi'
    }).whenComplete(
        () => debugPrint("yeni kullanıcı $newUserId sayısı ile eklendi"));

    _firestore.collection("users").document("hasan").updateData(
        {'okul': 'gazi'}).then((value) => debugPrint("hasan güncellendi."));
  }

  void transactionEkle() {
    final DocumentReference abdullahRef = _firestore.document("users/abdullah");

    _firestore.runTransaction((transaction) async {
      DocumentSnapshot abdullahData = await abdullahRef.get();
      if (abdullahData.exists) {
        var abdullahPara = abdullahData.data['para'];
        if (abdullahPara > 100) {
          await transaction.update(abdullahRef, {'para': abdullahPara - 100});
          await transaction.update(_firestore.document("users/hasan"),
              {'para': FieldValue.increment(100)});
        } else {
          debugPrint("işlemi gerçekleştirmek için hesapta yeterli para yok");
        }
      } else {
        debugPrint("Döküman bulunamadı");
      }
    });
  }

  void verisilme() {
    // dokuman silme
    _firestore.document("users/ayse").delete().then((value) {
      debugPrint("ayse silindi");
    });

    // dokuman içinden alan silme

    _firestore
        .document("users/hasan")
        .updateData({'bölüm': FieldValue.delete()}).then((value) {
      debugPrint("hasan içcerisinden veri silindi");
    });
  }

  void verioku() async {
    DocumentSnapshot document_snapshot =
        await _firestore.document("users/abdullah").get();
    // dokuman üzerinden okuma işlemleri
    debugPrint('dokuman id ' + document_snapshot.documentID);
    debugPrint("dokuman var mı" + document_snapshot.exists.toString());
    debugPrint('bekleyen yazma var mı : ' +
        document_snapshot.metadata.hasPendingWrites.toString());
    debugPrint('adı : ' + document_snapshot.data['ad']);
    debugPrint('sınıfı : ' + document_snapshot.data['sınıf'].toString());
    debugPrint('soyadı : ' + document_snapshot.data['soyad']);

    debugPrint('cacheden mi geldi : ' +
        document_snapshot.metadata.isFromCache.toString());
    document_snapshot.data.forEach((key, deger) {
      debugPrint("key : $key , deger : $deger");
    });

    //collectionun okunması
    _firestore.collection('users').getDocuments().then((querysnapshot) {
      debugPrint(querysnapshot.documents.length.toString());

      for (var i = 0; i < querysnapshot.documents.length; i++) {
        debugPrint(querysnapshot.documents[i].data.toString());
      }
    });

    //streamlarla değişikliklerin dinlenmesi

    DocumentReference ref = _firestore.document("users/abdullah");

    ref.snapshots().listen((dinlenenveri) {
      debugPrint("anlık : " + dinlenenveri.data.toString());
    });

    _firestore.collection('users').snapshots().listen((snap) {
      debugPrint(snap.documents.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("deneme"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: veriEkle,
                child: Text("Veri Ekle"),
              ),
              RaisedButton(
                onPressed: transactionEkle,
                child: Text("Transaction ekle"),
              ),
              RaisedButton(
                onPressed: verisilme,
                child: Text("Veri Sil"),
              ),
              RaisedButton(
                onPressed: verioku,
                child: Text("Veri okuma"),
              ),
              RaisedButton(
                onPressed: sorguyapma,
                child: Text("Sorgu yapma"),
              ),
              RaisedButton(
                onPressed: storageuploadfile,
                child: Text("Storage İşlemleri"),
              ),
              RaisedButton(
                  onPressed: cameraImageUpload, child: Text("Kamera Upload")),
              Expanded(
                  child: secilenresim == null
                      ? Text("Resim Yok")
                      : Image.file(secilenresim)),
            ],
          ),
        ),
      ),
    );
  }

  void sorguyapma() async {
    var dokumanlar = await _firestore
        .collection("users")
        .where("bölüm", isEqualTo: 'ybs')
        .getDocuments();

    for (var dokuman in dokumanlar.documents) {
      debugPrint(dokuman.data.toString());
    }

    var limitgetir =
        await _firestore.collection("users").limit(3).getDocuments();
    for (var limitget in limitgetir.documents) {
      debugPrint(limitget.data.toString());
    }

    var arrayquery = await _firestore
        .collection("users")
        .where("diller", arrayContains: 'dart')
        .getDocuments();
    for (var arrayget in arrayquery.documents) {
      debugPrint(arrayget.data.toString());
    }

    var abdullahDatas = _firestore
        .collection("users")
        .document("abdullah")
        .get()
        .then((datasnapshot) {
      debugPrint("abdullah'ın verileri :" + datasnapshot.data.toString());
    });
  }

  void storageuploadfile() async {
    var imagepicker = await ImagePicker.pickImage(source: ImageSource.gallery); //galeri bölümünün açılması

    setState(() {
      secilenresim = imagepicker;  // galeriden seçilen elemanın ekranda gösterilmesi 
    });
    StorageReference referance = FirebaseStorage.instance
        .ref()
        .child("users")
        .child("abdullah")
        .child("abdullah.png"); // firebase üzerinde kayıt olcağı yolu veriyoruz.
    StorageUploadTask uploadfile = referance.putFile(secilenresim);  // upload işlemi 
    var url = await (await uploadfile.onComplete).ref.getDownloadURL();
    debugPrint("indirme linki : " + url);
  }

  void cameraImageUpload() async {
    var cameraPicker = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      secilenresim = cameraPicker; // kamera bölümünün açılması s
    });

    StorageReference cameraref = FirebaseStorage.instance
        .ref()
        .child("users")
        .child("abdullah")
        .child(
            "abdulah2.png"); // firebase üzerinde kayıt olcağı yolu veriyoruz.

    StorageUploadTask cameraUploadTask = cameraref.putFile(secilenresim);
    var cameraUrl =
        await (await cameraUploadTask.onComplete).ref.getDownloadURL();  // indirme linkkinin alınması 

    debugPrint("camera kullanılarak  storage işlemi " + cameraUrl);
  }
}
