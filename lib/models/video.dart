
class Video{
  //atributos
  final String id;
  final String titulo;
  final String imagem;
  final String canal;

  //metodos
  Video({required this.id, required this.titulo, required this.imagem, required this.canal});//construtor

  factory Video.fromJson(Map<String, dynamic> json){
    if(json.containsKey('id')) {
      //converte o Mapa Json vindo do servidor do google em um objeto Video e ja retorna este objeto
      return Video(
          id: json['id']['videoId'],
          titulo: json['snippet']['title'],
          imagem: json['snippet']['thumbnails']['high']['url'],
          canal: json['snippet']['channelTitle']
      );
    }else{
      //converte o Mapa Json vindo de uma lista (lista dis videos favoritados) um objeto Video e ja retorna este objeto
      return Video(
          id: json['videoId'],
          titulo: json['titulo'],
          imagem: json['imagem'],
          canal: json['canal']
      );
    }
  }

  //funcao para transformar um objeto video em formato Json
  Map<String, dynamic> toJson(){
    return {
      'videoId' : id,
      'titulo' : titulo,
      'imagem' : imagem,
      'canal' : canal
    };
  }

}