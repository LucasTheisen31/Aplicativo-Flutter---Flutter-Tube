import 'dart:convert';
import 'package:flutter_tube/models/video.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'AIzaSyCHJ5m3ksg3Ibqwq0X9IP2_c3e6k0Vf_B4';
//api youtube

class Api {
  ///atributos
  String? _search;
  String? _nextPageToken;

  ///metodos
  Future<List<Video>> search(String? search) async {
    _search = search; //armazena a palavra pesquisada

    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"));

    return decode(response);
  }

  Future<List<Video>> nextPage() async {//retorna a lista dos proximos 10 videos
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextPageToken"));

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      //200 OK é a resposta de status de sucesso que indica que a requisição foi bem sucedida.
      var decoded = jsonDecode(response.body);

      //armazena o token da proxima pagina, vai ter mais items da pesquisa
      _nextPageToken = decoded['nextPageToken'];

      List<Video> listaVideos = decoded['items'].map<Video>((map) {
        //chama o metodo para converter de json que possui uma lista de mapas, para um objeto video
        //faz isso pra todos os items do Json
        return Video.fromJson(map);
      }).toList(); //transforma tudos os objetos video em uma lista de video;

      return listaVideos;
    } else {
      //lança uma exeção
      throw Exception('Falha ao carregar os videos');
    }
  }
}
