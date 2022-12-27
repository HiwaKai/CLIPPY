import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/*
 * 動画ウィジェット
 */
class PlayerMovie extends StatefulWidget {

  String movieURL; // 動画URL
  PlayerMovie(this.movieURL) : super();
  @override
  _PlayerMovieState createState() => _PlayerMovieState();
}

/*
 * ステート
 */


class _PlayerMovieState extends State<PlayerMovie> {

  // コントローラー
  late VideoPlayerController _controller;

  @override
  void initState() {

    // 動画プレーヤーの初期化
    _controller = VideoPlayerController.network(
        widget.movieURL
    )..initialize().then((_) {

      setState(() {});
      _controller.play();
    });

    super.initState();
  }

  _myDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Congraturation!"),
          content: const Text("URLコピー完了"),
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

  Future CopyURL() async{
    final data = ClipboardData(text: widget.movieURL);
    await Clipboard.setData(data);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => {
                CopyURL(),
                _myDialog()
              },
              icon: Icon(Icons.upload_file))
        ],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Container(
            width: 160,
            height: 160,
            child: Image.asset(
                'images/ClIPPY.png'
            ),
          )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // 動画を表示
            child: VideoPlayer(_controller),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  // 動画を最初から再生
                  _controller
                      .seekTo(Duration.zero)
                      .then((_) => _controller.play());
                },
                icon: Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  // 動画を再生
                  _controller.play();
                },
                icon: Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: () {
                  // 動画を一時停止
                  _controller.pause();
                },
                icon: Icon(Icons.pause),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}