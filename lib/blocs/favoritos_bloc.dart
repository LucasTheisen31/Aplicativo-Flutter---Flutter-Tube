import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosBloc implements BlocBase {
  FavoritosBloc() {
    //construtor
    //quando iniciar o FavoritosBloc vai verificar se ja existe uma lista de favoritos salva
    SharedPreferences.getInstance().then((value) {
      if (value.getKeys().contains('favoritos')) {
        //se ja existe uma lista de favoritos salva
        _favoritos =
            json.decode(value.getString('favoritos')!).map((key, valor) {
          return MapEntry(key, Video.fromJson(valor));
        }).cast<String, Video>();
        //depois de obter a lista dos favoritos vou passar esse lista de favoritos para o _streamControllerFavoritos
        _streamControllerFavoritos.add(_favoritos);
      }
    });
  }

  Map<String, Video> _favoritos = {};

  //BehaviorSubject Um StreamController especial que captura o último item que foi adicionado ao controlador e o emite como o primeiro item para qualquer novo ouvinte.
  final _streamControllerFavoritos = BehaviorSubject<Map<String, Video>>.seeded({});

  //getter para dar acesso a stream (saida dos dados de _streamControllerFavoritos)
  Stream<Map<String, Video>> get getStreamFavoritos =>
      _streamControllerFavoritos.stream;

  //funcao que adiciona ou remove um video do mapa de favoritos
  void toggleFavorite(Video video) {
    //se o mapa de _favoritos contem um video com o id do video passado
    //ou seja se este video passado ja esta no mapa de favoritos
    if (_favoritos.containsKey(video.id)) {
      //remove o video do mapa passando o id dele
      _favoritos.remove(video.id);
    } else {
      //senao adiciona o video no mapa
      _favoritos[video.id] = video;
    }
    //envia o mapa atualizado dos favoritos para o _streamControllerFavoritos
    _streamControllerFavoritos.sink.add(_favoritos);
    //chama a função para salvar os favoritos localmente
    _saveFav();
  }

  _saveFav(){
    SharedPreferences.getInstance().then((value){
      value.setString('favoritos', json.encode(_favoritos));
    });
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    //fecha a Stream
    _streamControllerFavoritos.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
