import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favoritos_bloc.dart';
import 'package:flutter_tube/pages/youtube_player_page.dart';
import '../models/video.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //para dar acesso ao bloc dos favoritos
    final bloc = BlocProvider.getBloc<FavoritosBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, Video>>(
        initialData: {},
        // stream = vai observar BlocProvider.getBloc<FavoritosBloc>().getStreamFavoritos
        stream: bloc.getStreamFavoritos,
        //quando tiver alteração vai construir o builder, ou seja quando tiver alteração na lista de favoritos vai atualizzar a StreamBulder
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data!.values.map((e) {
              return InkWell(
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: Image.network(e.imagem),
                    ),
                    Expanded(
                      child: Text(e.titulo),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubePlayerPage(video: e,),));
                },
                onLongPress: (){
                  //remove o video favorito da lista
                  bloc.toggleFavorite(e);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
