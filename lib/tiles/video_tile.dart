// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/pages/youtube_player_page.dart';
import '../blocs/favoritos_bloc.dart';
import '../models/video.dart';

class VideoTile extends StatelessWidget {
  VideoTile({Key? key, required this.video}) : super(key: key);

  final Video video;
  //Map<String, Video> map = {};
  final block = BlocProvider.getBloc<FavoritosBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      //margin do lado de fora do container
      child: Column(
        //para a imagem ocupar o espaço total na horizontal
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: (){
              //chama o widget que vai executar o video
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubePlayerPage(video: video),));
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video.imagem,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  //alinha no inicio
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.titulo,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 2, //vai ocupar no max 2 linhas
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.canal,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<Map<String, Video>>(
                //pega a saida (Stream) do Bloc de favoritos, ou seja sempre queu alterar a lista de favoritos vai refazer o botao de add favoritos
                stream: block.getStreamFavoritos,
                //initialData: map,
                builder: (context, snapshot) {
                  //snapshot vai conter o mapa de favoritos
                  if (snapshot.hasData) {
                    //se o snapshot contem dados
                    return IconButton(
                      onPressed: () {
                        block.toggleFavorite(video);
                      },
                      icon: Icon(
                          //verifica se o video mostrado esta no mapa de favoritos
                          //se estiver vai mostrar o icone de favorito preenchido, senao mostra ele vazio
                          snapshot.data!.containsKey(video.id)
                              ? Icons.star
                              : Icons.star_border),
                      color: Colors.black,
                      iconSize: 30,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
