import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:movies/controllers/auth_controller.dart';

import 'package:movies/widgets/user_favorites_card_widget.dart';
import '../bloc/movies_bloc/cubit.dart';
import '../bloc/movies_bloc/movies_state.dart';
import '../bloc/movies_detail_bloc/cubit.dart';
import '../bloc/movies_playing_now_bloc/cubit.dart';
import '../bloc/movies_playing_now_bloc/state.dart';
import '../database/controller.dart';
import '../models/movies_favorite.dart';
import '../models/movies_playing_now.dart';
import '../utils/textStyles.dart';

import '../widgets/playingNow_card_widget.dart';

import 'movie_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<MoviesPlayingNowCubit>(context);

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          moviesPlayingNowRow(_bloc),
          SizedBox(
            height: 30,
          ),
          moviesPopularRow(),
          SizedBox(
            height: 30,
          ),
          userFavoriteMoviesRow(),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget userFavoriteMoviesRow() {
    AuthController controller = Get.put(AuthController());
    return GetBuilder<AuthController>(builder: (_) {
      return FirebaseAuth.instance.currentUser?.uid != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: controller.favorites,
              builder: (context, snapshot) {
                List? favorites = snapshot.data?['data'];

                if (snapshot.hasData) {
                  if (favorites?.length != 0) {
                    controller.setUserFavoriteIds(favorites);
                  }

                  print('Stream Çalıştı = ${_.userFavoriteIds}');
                  return Container(
                    alignment: favorites?.length == 0
                        ? Alignment.center
                        : Alignment.centerLeft,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: favorites?.length != 0
                        ? Container(
                            height: 250,
                            margin: const EdgeInsets.only(left: 8.0),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  favorites != null ? favorites.length : 0,
                              itemBuilder: (context, index) {
                                return UserFavoriteCard(
                                    favorites: favorites, index: index);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 10,
                                );
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: 200,
                            child: Text(
                              'Favori Listeniz Boş',
                              style: titleStyle,
                            ),
                          ),
                  );
                }
                return Container(
                  child: Text(
                    'Henüz giriş yapmadınız!',
                    style: titleStyle,
                  ),
                );
              })
          : Container(
              height: 200,
              alignment: Alignment.center,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Henüz giriş yapmadınız!',
                style: titleStyle,
              ),
            );
    });
  }

  Widget moviesFavoritesRow() {
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);
    return GetBuilder<FavoriteController>(
      builder: (_controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: _controller.favorite.length != 0
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              titleRow('İzleme Listen', tumunuGorText),
              SizedBox(
                height: 30,
              ),
              _controller.favorite.length != 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 250,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _controller.favorite.length,
                          itemBuilder: (context, index) {
                            MoviesFavorite movie = _controller.favorite[index];
                            return InkWell(
                              onTap: () {
                                _bloc.setMovieId(movie.movieId);

                                Get.to(MovieDetailView(
                                  imagePath: movie.imagePath,
                                ));
                              },
                              child: CardMoviesPlayingNow(
                                id: movie.movieId,
                                imagePath: movie.imagePath,
                                title: movie.title,
                                rating: movie.voteAverage,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                        ),
                      ),
                    )
                  : Container(
                      child: Text(
                        'İzleme listeniz boş',
                        style: movieTitleStyle,
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  Container moviesPlayingNowRow(MoviesPlayingNowCubit _bloc) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[850], borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          titleRow('Vizyonda', tumunuGorText),
          SizedBox(
            height: 30,
          ),
          playingNowBloc(_bloc),
        ],
      ),
    );
  }

  Container moviesPopularRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: Colors.grey[850], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          titleRow('Popüler', tumunuGorText),
          SizedBox(
            height: 30,
          ),
          popularBloc(),
        ],
      ),
    );
  }

  BlocBuilder<MoviesCubit, MoviesPopularState> popularBloc() {
    return BlocBuilder<MoviesCubit, MoviesPopularState>(
        builder: (context, state) {
      if (state is MoviesPopularInitialState) {
        final _bloc = BlocProvider.of<MoviesCubit>(context);
        _bloc.getMoviePopular(_bloc.pageNum);
      } else if (state is MoviesPopularLoadingState) {
        return loadingIndicator();
      } else if (state is MoviesPopularLoadedState) {
        return popularRow(state);
      } else if (state is MoviesPopularErrorState) {
        return Text('Hata alındı');
      }
      return Container();
    });
  }

  BlocConsumer<MoviesPlayingNowCubit, MoviesPlayingNowState> playingNowBloc(
      MoviesPlayingNowCubit _bloc) {
    return BlocConsumer<MoviesPlayingNowCubit, MoviesPlayingNowState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MoviesPlayingNowInitialState) {
          _bloc.getMoviePlayingNow(_bloc.pageNum);
          print('Şu andaki Filmler Getiriliyor View');
          return Center(
            child: Text(
              'Hoşgeldiniz',
              style: bodyText,
            ),
          );
        } else if (state is MoviesPlayingNowLoadingState) {
          return loadingIndicator();
        } else if (state is MoviesPlayingNowLoadedState) {
          return playingNowRow(state);
        } else if (state is MoviesPlayingNowErrorState) {
          errorDialog(context, state);
        }
        return Container();
      },
    );
  }

  Widget popularRow(MoviesPopularLoadedState state) {
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Container(
        height: 250,
        child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              var data = state.popularMoviesPopular!.results![index];

              return InkWell(
                onTap: () {
                  _bloc.setMovieId(data!.id!);

                  Get.to(MovieDetailView(
                    imagePath: data.posterPath,
                  ));
                },
                child: CardMoviesPlayingNow(
                  id: data!.id,
                  imagePath: data.posterPath,
                  title: data.originalTitle,
                  rating: data.voteAverage,
                ),
              );
            }),
      ),
    );
  }

  Widget playingNowRow(MoviesPlayingNowLoadedState state) {
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: 250,
        child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              Result? data = state.playingNowMovies!.results![index];
              return InkWell(
                onTap: () {
                  _bloc.setMovieId(data!.id!);

                  Get.to(MovieDetailView(
                    imagePath: data.posterPath,
                  ));
                },
                child: CardMoviesPlayingNow(
                  id: data!.id,
                  imagePath: data.posterPath,
                  title: data.originalTitle,
                  rating: data.voteAverage,
                ),
              );
            }),
      ),
    );
  }

  Widget titleRow(String title, Widget tumunuGor) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            tumunuGorText
          ],
        ),
      );

  Widget get tumunuGorText => Text(
        'Tümünü Gör',
        style: tumunuGorTextStyle,
      );

  Future<dynamic> errorDialog(
      BuildContext context, MoviesPlayingNowErrorState state) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Beklenmedik bir Hata oluştu'),
              content: Text(state.message),
            ));
  }

  Center loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
