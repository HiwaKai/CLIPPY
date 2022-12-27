import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:untitled/trash/MoviePlayerWidget.dart';
import 'package:untitled/PlayerMovie.dart';
import 'package:untitled/login_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../create_acount_page.dart';
import '../firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'folder_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

//videoのパスを受け取って,サムネイル画像を作成

// MyApp,MyHomePageはデフォルトから変更がないため省略

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  String URL = "";
  // 入力したメールアドレス・パスワード
  String _email = '';
  String _password = '';
  String _filename = '';

  String videoPath = '';

  Future upload_firebase_movie() async {
    final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print(userID);
    Uint8List? Video = await ImagePickerWeb.getVideoAsBytes();
    if (Video != null) {
      //Storageへのアップデート
      FirebaseStorage.instance.ref("sample").child("users/$userID/movie/$_filename").putData(Video, SettableMetadata(contentType: "video/mp4"));
      //FireStoreへのデータ追加 ファイル名とPathが分かればよい？
      FirebaseFirestore.instance.collection('users').doc(userID).collection('movie').doc(_filename).set({'title': _filename,'file_name': _filename});
    }
  }

  //firestore関連
  void firestore(){
    final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance.collection('users').doc(userID).collection('movie').doc(_filename).set({'title': _filename,'file_name': _filename});
  }

  Future download_firebase_movie() async {
    final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    final imageURL = await FirebaseStorage.instance.ref("sample").child("users/$userID/movie/movie.mp4").getDownloadURL();

    URL = imageURL;
    print("URL");
  }

  final List<String> videoURL = [];
  String val = "";

  Future download_firebase_movie_All() async{
    final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      final result = await FirebaseStorage.instance.ref("sample").child(
          "users/$userID").listAll();
      for(var item in result.items){
        final url = await item.getDownloadURL();
        val = url;
        videoURL.add(val);
      }

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 1行目 メールアドレス入力用テキストフィールド
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              // 2行目 パスワード入力用テキストフィールド
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'ファイルネーム'),
                obscureText: true,
                onChanged: (String value){
                  setState(() {
                    _filename = value;
                  });
                },
              ),
              // 3行目 ユーザ登録ボタン
              ElevatedButton(
                child: const Text('ユーザ登録'),
                onPressed: () async {
                  try {
                    final User? user = (await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: _email, password: _password))
                        .user;
                    if (user != null)
                      print("ユーザ登録しました ${user.email} , ${user.uid}");
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // 4行目 ログインボタン
              ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final User? user = (await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: _email, password: _password))
                        .user;
                    if (user != null)
                      print("ログインしました　${user.email} , ${user.uid}");
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // 5行目 パスワードリセット登録ボタン
              ElevatedButton(
                  child: const Text('パスワードリセット'),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _email);
                      print("パスワードリセット用のメールを送信しました");
                    } catch (e) {
                      print(e);
                    }
                  }),

              ElevatedButton(
                  child: const Text('動画'),
                  onPressed: firestore
              ),
              ElevatedButton(
                  child: const Text('URLSet'),
                  onPressed: (){
                    download_firebase_movie();
                  }
              ),
              ElevatedButton(
                  child: const Text('動画再生'),
                  onPressed: (){
                    if(URL != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => folder_page(URL)),
                      );
                    }else{
                      print("error");
                    }
                  }
              ),
              ElevatedButton(
                  child: const Text('All'),
                  onPressed: download_firebase_movie_All
              ),
              ElevatedButton(
                  child: const Text('AllPrint'),
                  onPressed: (){
                    for(var val in videoURL){
                      print(val);
                    }
                  }
              ),

              ElevatedButton(
                  child: const Text('test'),
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context){
                              return login_page();
                            }
                        )
                    );
                  }
              ),

              ElevatedButton(
                  child: const Text('Create'),
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context){
                              return create_acount_page();
                            }
                        )
                    );
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}