//選択した動画のパスを入れる
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailRequest{
  final String video;
  const ThumbnailRequest({
    required this.video
  });
}

//作成したサムネイル画像を入れる
class ThumbnailResult{
  final Image image;
  const ThumbnailResult({
    required this.image
  });
}

//サムネイルを作成し、Completerに乗せて送り出す
Future<ThumbnailResult> getThumbnail(ThumbnailRequest r) async {
  Uint8List? bytes;

  ///CompleterはFutureでデータを運ぶ役割を担う
  final Completer<ThumbnailResult> completer = Completer();
  bytes = await VideoThumbnail.thumbnailData(
    video: r.video,
  );
  final _image = Image.memory(bytes!);
  print(_image);
  completer.complete(ThumbnailResult(
    image: _image,
  ));
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  final ThumbnailRequest thumbnailRequest;

  const GenThumbnailImage({required Key key, required this.thumbnailRequest}) : super(key: key);
  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
        future: getThumbnail(widget.thumbnailRequest),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final _image = snapshot.data.image;
            return Column(
              children: [
                _image,
              ],
            );
          } else {
            return Container();
          }
        });
  }
}