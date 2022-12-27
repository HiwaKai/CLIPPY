import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main_page.dart';
import 'package:untitled/reset_pass_page.dart';

import 'create_acount_page.dart';

class login_page extends StatefulWidget{
  @override
  _login_page_state createState() => _login_page_state();
}

class _login_page_state extends State<login_page>{

  //メールアドレス変数
  String _mail = "";
  //パスワード変数
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 40),

          child: Stack(children: [

            _loginForm(),


            Container(
                alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context){
                              return create_acount_page();
                            })
                          )
                      },
                      child: Text('アカウントを持っていませんか？')
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return reset_pass_page();
                          })
                      )
                    },
                      child: Text('パスワードを忘れましたか?')
                  )
                ],
              )
            )
          ])),
    );
  }

  Widget _loginForm(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'e-mail'),
          onChanged: (String value){
            setState(() {
              _mail = value;
            });
          },
        ),
        //password入力フィールド
        TextFormField(
          decoration: InputDecoration(labelText: 'PassWord'),
          obscureText: true,
          onChanged: (String value){
            setState(() {
              _password = value;
            });
          },
        ),
        //ログインButton
        TextButton(
          child: const Text('Login'),
          onPressed: () async {
            if(_mail != null && _password != null) {
              try {
                // メール/パスワードでログイン
                final User? user = (await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                    email: _mail, password: _password))
                    .user;

                if (user != null)
                  print("ログインしました　${user.email} , ${user.uid}");

                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return MyStatefulWidget();
                      })
                );
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




class Data{
  static List<String> videoUrl = [];
}