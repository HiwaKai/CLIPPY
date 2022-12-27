import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';



class upload_page extends StatefulWidget{
  @override
  _upload_page_state createState() => _upload_page_state();
}

class _upload_page_state extends State<upload_page>{
  String _filename = "";
  String _title = "";
  String  _URL = "";


  Future upload_firebase_movie() async {

    final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print(userID);
    Uint8List? Video = await ImagePickerWeb.getVideoAsBytes();
    if (Video != null) {
      _filename = _title + ".mp4";
      //Storageへのアップデート
      await FirebaseStorage.instance.ref().child("user/$userID/movie/$_filename").putData(Video, SettableMetadata(contentType: "video/mp4"));

      //StorageからのダウンロードURL取得
      _URL = await FirebaseStorage.instance.ref().child("user/$userID/movie/$_filename").getDownloadURL();
      //FireStoreへのデータ追加 ファイル名とPathが分かればよい？
      FirebaseFirestore.instance.collection('user').doc(userID).collection('movie').doc(_title).set({'title': _title, 'URL': _URL});
    }
  }

  _myDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congraturation!"),
        content: const Text("アップロード完了"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("close")
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '動画タイトル'),
              obscureText: false,
              onChanged: (String value){
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 30),
            IconButton(
                icon: const Icon(Icons.file_upload),
                iconSize: 30,
                onPressed: () async {
                  if(_title != null) {
                    await upload_firebase_movie();
                    _myDialog();
                  }
                  else{
                    print('e');
                  }
                },
            ),
          ],
        ),
      ),
      ),
    );
  }
}