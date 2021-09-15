import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_bloc/cubit.dart';
import 'package:movies/bloc/movies_bloc/movies_state.dart';
import 'package:movies/bloc/movies_playing_now_bloc/cubit.dart';
import 'package:movies/repository/movies_repository.dart';
import 'package:movies/views/bottomNavBar_view.dart';
import 'package:movies/views/home_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: HomeView(),
        ),
      ),
    );
  }
}
