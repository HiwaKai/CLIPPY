import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/login_page.dart';
import 'package:untitled/screens/movie_view.dart';
import 'package:untitled/screens/upload_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter app',
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // スプラッシュ画面などに書き換えても良い
          return const SizedBox();
        }
        if (snapshot.hasData) {
          // User が null でなない、つまりサインイン済みのホーム画面へ
          return const MyStatefulWidget();
        }
        // User が null である、つまり未サインインのサインイン画面へ
        return login_page();
      },
    ),
  );
}



class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List _screens = [
    movie_view(),
    upload_page(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _logout() async{
    await FirebaseAuth.instance.signOut();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context){
        return login_page();
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: _logout,
              child: Text('Logout'))
        ],
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Container(
          width: 160,
          height: 160,
          child: Image.asset(
            'assets/images/ClIPPY.png'
          ),
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            DrawerHeader(
              child: Text(
                'Clippy',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.black45
              ),
            ),
            ListTile(
              title: Text('フォルダー(近日実装予定)'),
              onTap: null,
            ),
          ],
        ),
      ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '動画'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'アップロード'),
          ],
          type: BottomNavigationBarType.fixed,
        ),
    );
  }
}

