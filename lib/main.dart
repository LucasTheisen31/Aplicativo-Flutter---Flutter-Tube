// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/api.dart';
import 'package:flutter_tube/blocs/favoritos_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //lista dos blocs
        Bloc((i) => VideosBloc()),
        Bloc((i) => FavoritosBloc()),
      ],
      dependencies: [],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white24,
            foregroundColor: Colors.black,//cor dos textos
            iconTheme: IconThemeData (
              color: Colors.black , //cor dos icones da app bar
            ),
          )
        ),
        title: 'Flutter Tube',
        home: HomePage(),
      ),
    );
  }
}
