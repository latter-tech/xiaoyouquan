import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/blog_model.dart';

/**
 * 视频显示组件
 */
class BlogVideoWidget extends StatefulWidget {
  BlogVideoWidget({
    Key? key,
    required this.model,
    required this.isQuote
  }) : super(key: key);

  final BlogModel model;
  final bool isQuote;

  @override
  State<StatefulWidget> createState() => _BlogVideoWidget();
}

class _BlogVideoWidget extends State<BlogVideoWidget> {

  late String cover;
  late String mp4;
  late double width;
  late double heigth;
  late VideoPlayerController _videoController;
  late Future _initVideoPlayerFuture;
  late ChewieController _chewieController;

  bool _isCoverVisible = true;

  @override
  void initState() {
    super.initState();
    mp4 = widget.model.assets![0].video ?? '';
    cover = widget.model.assets![0].large ?? '';
    width = widget.model.assets![0].width!.toDouble() ?? 0;
    heigth = widget.model.assets![0].height!.toDouble() ?? 0;
  }

  Future<void> initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(mp4));
    await Future.wait([
      _videoController.initialize()
    ]);
    _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: _videoController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        showOptions: false,
        showControlsOnInitialize: false
    );
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    double _maxWidth = MediaQuery.of(context).size.width - 70;
    double _maxHeith = 600;

    if( width >  _maxWidth) {
      double oldWidth = width;
      width = _maxWidth;
      heigth = width / oldWidth * heigth;
    }

    if( heigth > _maxHeith ) {
      double oldHeigth = heigth;
      heigth = _maxHeith;
      width = heigth / oldHeigth * width;
    }

    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 20, right:10),
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 70,
                maxHeight: MediaQuery.of(context).size.width - 70
            ),
            child: Container(
                height: heigth,
                child: _isCoverVisible ? GestureDetector(
                  child: Image.network(cover),
                  onTap: () {
                    setState(() {
                      _isCoverVisible = false;
                      _initVideoPlayerFuture = initializePlayer();
                    });
                  },
                ) : FutureBuilder(
                    future: _initVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if( snapshot.connectionState == ConnectionState.done ) {
                        return AspectRatio(
                            aspectRatio: _chewieController.aspectRatio!,
                            child: Chewie(
                              controller: _chewieController,
                            )
                        );
                      } else {
                        return Container(
                          height: heigth,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              )
                          ),
                        );
                      }
                    }
                )
            )
        )
    );

  }

  @override
  void dispose() {
    super.dispose();
    // _videoController.dispose();
    // _chewieController.dispose();
  }

}