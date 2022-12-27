import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/login_page.dart';

class reset_pass_page extends StatefulWidget{
  @override
  reset_pass_page_state createState() => reset_pass_page_state();
}

class reset_pass_page_state extends State<reset_pass_page> {

  String _mail = "";

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
          decoration: InputDecoration(labelText: 'e-mail'),
          onChanged: (String value) {
            setState(() {
              _mail = value;
            });
          },
        ),
        //ログインButton
        TextButton(
          child: const Text('再設定メールを送信'),
          onPressed: () async {
            try {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: _mail);
              print("パスワードリセット用のメールを送信しました");
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }
}