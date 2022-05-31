// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favoritos_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/dellegates/data_search.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/pages/favoritos_page.dart';

import '../tiles/video_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  //Map<String, Video> map = {};
  //final bloc = BlocProvider.getBloc<FavoritosBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          height: 25,
          child: Image.asset('assets/images/youtube-logo.png'),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              //initialData: map,
              //pega a saida (Stream) do Bloc de favoritos, ou seja sempre queu alterar a lista de favoritos vai refazer o botao de add favoritos
              stream: BlocProvider.getBloc<FavoritosBloc>().getStreamFavoritos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //se snapshot tiver dados
                  return Text('${snapshot.data!.length}');
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritosPage(),));
            },
            icon: Icon(Icons.star_border_outlined),
          ),
          IconButton(
            onPressed: () async {
              //result vai receber o retorno do metodo close(BuildContext context, String result)
              String? result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                BlocProvider.getBloc<VideosBloc>().getSinkSearch.add(result);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
        //vai observar BlocProvider.getBloc<VideosBloc>().getStreamVideos
        stream: BlocProvider.getBloc<VideosBloc>().getStreamVideos,
        //quando tiver alteração vai construir o builder
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              //funcao chamada a cada item do snapshot
              itemBuilder: (BuildContext context, int index) {
                if (index < snapshot.data!.length) {
                  //chama o widget (VideoTile) que vai exibir o video passado no snapshot.data[index]
                  return VideoTile(video: snapshot.data[index]);
                } else {
                  //quando chegar no ultimo item da lista entao vai passar null para a busca, para carregar mais items da mesma busca, api.nextPage()
                  BlocProvider.getBloc<VideosBloc>().getSinkSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
              },
            );
          } else {
            //se o snapshot nao conter dados
            return Container();
          }
        },
      ),
    );
  }
}
