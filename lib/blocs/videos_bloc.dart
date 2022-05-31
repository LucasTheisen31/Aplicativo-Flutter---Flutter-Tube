import 'dart:async';
import 'dart:ui';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/api.dart';
import '../models/video.dart';

/*widgets submetem eventos; outros widgets responderão. BLoC fica no meio, gerenciando a conversa
o block sera a ponte entre a API e os Widgets
sink onde entra os dados na StreamControler
stream onde sai os dados na StreamControler
*/

class VideosBloc implements BlocBase {
  ///atributos
  late Api api;
  List<Video> listaVideos = [];
  final StreamController<List<Video>> _streamControllerVideos =
      StreamController<List<Video>>();
  final StreamController<String?> _streamControllerSearch =
      StreamController<String?>();

  ///metodos
  //construtor
  VideosBloc() {
    api = Api();
    //sempre que _streamControllerSearch receber um dado (nova busca) vai chamar a funcao _search
    _streamControllerSearch.stream.listen(_search);
  }

  //getter para dar acesso a stream (saida dos dados de _streamControllerVideos)
  Stream get getStreamVideos => _streamControllerVideos.stream;

  //geter para dar acesso  a Sink (entrada dos dados de _streamControllerSearch)
  //esse dado qe vai entrar é a pesquisa
  Sink get getSinkSearch => _streamControllerSearch.sink;

  void _search(String? search) async {
    if (search != null) {
      //se for uma nova busca sendo realizada
      //manda uma lista vazia para a entrada de dados(sink) do _streamControllerVideos, para ele reconstruir a tela sem items
      // para que a proxima busca comece do inicio
      _streamControllerVideos.sink.add([]);
      //chama o metodo de busca da API(passando a busca) e esse metodo retorna a lista de videos resultante da busca
      listaVideos = await api.search(search);
    } else {
      //se nao for uma nova busca, somente vai carregar mais items da mesma busca, api.nextPage() retorna a lista dos proximos 10 videos;
      listaVideos += await api.nextPage();
    }
    //Passa a lista de video para o _streamControllerVideos
    _streamControllerVideos.sink.add(listaVideos);
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    //fecha a Stream
    _streamControllerVideos.close();
    _streamControllerSearch.close();
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
