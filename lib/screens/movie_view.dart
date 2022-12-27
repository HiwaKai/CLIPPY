import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/PlayerMovie.dart';

class movie_view extends StatefulWidget{

  @override
  _movie_view_state createState() => _movie_view_state();
}

class _movie_view_state extends State<movie_view>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //FirebaseStorageからのデータ取得後にWidget表示
        child: FutureBuilder(
          future: download_firestore_data(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return Scaffold(
                body: Center(
                  child: Container(
                    padding:const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext, int index){
                          return Card(
                            elevation: 50,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: ListTile(
                              trailing: Icon(Icons.play_circle_filled),
                              title: Text('Title: '+ snapshot.data[index]['title']),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> PlayerMovie(snapshot.data[index]['URL'])
                                )
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              );
            }
            else{
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

}

//FirebaseStorageから動画URLを取得する
Future download_firebase_movie_All() async{
  List<String> videoUrl = [];
  var val;

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    final result = await FirebaseStorage.instance.ref("sample").child("users/$userID/movie").listAll();
    for(var item in result.items){
      final url = await item.getDownloadURL();
      val = url;
      videoUrl.add(val);
    }
  }catch(e){
    print(e);
  }

  return videoUrl;
}


Future download_firestore_data() async{

  List data_list = [];

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  final collectionRef = FirebaseFirestore.instance.collection('user/$userID/movie');
  final querySnapshot = await collectionRef.get();
  final queryDocSnapshot = querySnapshot.docs;
  for(final snapshot in queryDocSnapshot){
    final data = snapshot.data();
    data_list.add(data);
  }
  return data_list;
}
