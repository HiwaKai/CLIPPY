import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class folder_page extends StatefulWidget{
  String movieURL; // 動画URL
  folder_page(this.movieURL) : super();

  @override
  _folder_page_state createState() => _folder_page_state();
}

class _folder_page_state extends State<folder_page>{
  late VideoPlayerController _controller;

  @override
  void initState() {

    // 動画プレーヤーの初期化
    _controller = VideoPlayerController.network(
        widget.movieURL
    )..initialize().then((_) {

      setState(() {});
      _controller.setVolume(0.0);
      _controller.play();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying ? _controller!.pause() : _controller!.play();
          });
        },
        child: Container(
          width: 500,
          height: 500,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}