import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'bloc/movies_detail_bloc/cubit.dart';
import 'bloc/movies_search_bloc/cubit.dart';
import 'bloc/movies_videos_bloc/cubit.dart';
import 'controllers/bindings/auth_binding.dart';
import 'database/controller.dart';
import 'repository/movies_repository.dart';

import 'utils/router.dart';
import 'views/bottomNavBar_view.dart';

import 'bloc/movies_bloc/cubit.dart';
import 'bloc/movies_playing_now_bloc/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => MoviesCubit(
        MovieRepository(),
      ),
    ),
   
    BlocProvider(
      create: (context) => MoviesPlayingNowCubit(
        MovieRepository(),
      ),
    ),
    BlocProvider(
      create: (context) => MoviesDetailCubit(
        MovieRepository(),
      ),
    ),
    BlocProvider(
      create: (context) => MoviesVideosCubit(
        MovieRepository(),
      ),
    ),
    BlocProvider(
      create: (context) => MoviesSearchCubit(
        MovieRepository(),
      ),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movieternal',
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.grey[900],
          primaryColor: Colors.blueGrey[900],
          primaryTextTheme:
              TextTheme(subtitle2: TextStyle(color: Colors.white))),
      onGenerateRoute: RouteGeneration.generateRoute,
      initialRoute: '/',
    );
  }
}

class DashBoard extends StatefulWidget {
  DashBoard({
    Key? key,
  }) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();

    GetBuilder<FavoriteController>(
      builder: (controller) {
        return Container();
      },
    );
    Future.delayed(Duration(seconds: 1)).whenComplete(
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Movies App',
              style: Theme.of(context).primaryTextTheme.subtitle2,
            ),
            CircularProgressIndicator(
              color: Colors.blueAccent[800],
            )
          ],
        ),
      ),
    );
  }
}
