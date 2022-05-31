import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/video.dart';

class YoutubePlayerPage extends StatefulWidget {
  const YoutubePlayerPage({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState(video);
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {

  @override
  void initState() {
    super.initState();
    runPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    _controller.pause();
  }

  _YoutubePlayerPageState(this._video); //construtor

  late YoutubePlayerController _controller;
  Video _video;

  void runPlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: _video.id,
      flags: YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: true,
        isLive: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Player YouTube',),
            centerTitle: false,
          ),
          body: Container(
              child: ListView(
                children: [
                  // some widgets
                  player,
                  //some other widgets
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(_video.titulo, maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text('Canal: ${_video.canal}', style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  )
                ],
              ),
          ),
        );
      },
    );
  }
}


