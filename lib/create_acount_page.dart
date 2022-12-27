import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/login_page.dart';

class create_acount_page extends StatefulWidget{
  @override
  _create_acount_page_state createState() => _create_acount_page_state();
}

class _create_acount_page_state extends State<create_acount_page> {

  String _mail = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 40),

          child: Stack(children: [

            _CreateForm(),

            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return login_page();
                          })
                        );
                      },
                      child: const Text('ログインページへ'))
                ],
              )
            )
          ])),
    );
  }

  Widget _CreateForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'e_mail'),
          onChanged: (String value) {
            setState(() {
              _mail = value;
            });
          },
        ),
        //password入力フィールド
        TextFormField(
          decoration: InputDecoration(labelText: 'PassWord'),
          onChanged: (String value) {
            setState(() {
              _password = value;
            });
          },
        ),
        //ログインButton
        TextButton(
          child: const Text('登録'),
          onPressed: () async {
            if(_mail != null || _password != null){
              try {
                final User? user = (await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: _mail, password: _password))
                    .user;
                if (user != null)
                  print("ユーザ登録しました ${user.email} , ${user.uid}");
              } catch (e) {
                print(e);
              }
            }
            else{
              print('e');
            }
          },
        ),
      ],
    );
  }
}