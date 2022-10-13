import 'package:flutter_candy/bloc/bloc_provider.dart';
import 'package:flutter_candy/bloc/game_bloc.dart';
import 'package:flutter_candy/pages/home_page.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      bloc: GameBloc(),
      child: MaterialApp(
        title: 'Flutter Crush',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
