import 'package:flutter/material.dart';
import '../main.dart';
import '../views/home_view.dart';
import '../views/main_screen.dart';
import '../views/movie_detail_view.dart';

class RouteGeneration {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashBoardRoute:
        return MaterialPageRoute(builder: (_) => DashBoard());
      case mainScreenRoute:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case detailScreenRoute:
        return MaterialPageRoute(builder: (_) => MovieDetailView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Ters giden birşeyler oldu'),
            ),
          ),
        );
    }
  }
}

const String dashBoardRoute = '/';
const String mainScreenRoute = '/mainScreen';
const String homeScreenRoute = '/homeScreen';
const String detailScreenRoute = '/detailScreen';
