import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    //icones da direita
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override

  @override
  Widget? buildLeading(BuildContext context) {
    //icone da esquerda
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {//ao clicar no botao pesquisar
    Future.delayed(Duration.zero).then((value) => close(context, query));
    return Container();
  }

  //modifica o texto hint do campo de pesquisa
  @override
  String get searchFieldLabel => 'Pesquisar';

  @override
  Widget buildSuggestions(BuildContext context) {
    //metodo chamado quando digita algo na pesquisa
    if (query.isEmpty) {
      //se a pesquisa for vazia
      return Container();
    } else {
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //se o snapshot nao contem dados
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data?.length, //numero de itens da lista
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    leading: Icon(Icons.search),
                    onTap: () {
                      //ao clicar em uma sugestao de busca
                      close(context, snapshot.data![index]);
                    },
                  );
                }));
          }
        },
      );
    }
  }

  Future<List> suggestions(String search) async {
    //funcao p/ mostrar as sugestoes de pesquisa

    http.Response response = await http.get(Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"));

    if (response.statusCode == 200) {
      //200 OK é a resposta de status de sucesso que indica que a requisição foi bem sucedida.
      var decoded = jsonDecode(response.body)[1].map((v) {
        return v[0];
      }).toList();

      return decoded;
    } else {
      //lança uma exeção
      throw Exception('Falha ao carregar as sugestões');
    }
  }
}
