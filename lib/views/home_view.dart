import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movies/bloc/movies_bloc/cubit.dart';
import 'package:movies/bloc/movies_bloc/movies_state.dart';
import 'package:movies/bloc/movies_detail_bloc/cubit.dart';
import 'package:movies/bloc/movies_playing_now_bloc/cubit.dart';
import 'package:movies/bloc/movies_playing_now_bloc/state.dart';
import 'package:movies/database/controller.dart';
import 'package:movies/models/movies_favorite.dart';
import 'package:movies/models/movies_playing_now.dart';
import 'package:movies/utils/textStyles.dart';

import 'package:movies/widgets/playingNow_card_widget.dart';

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
    FavoriteController controller = Get.put(FavoriteController());
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
          moviesFavoritesRow(),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget moviesFavoritesRow() {
    return GetBuilder<FavoriteController>(
      builder: (_controller) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey[850], borderRadius: BorderRadius.circular(10)),
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
                            return CardMoviesPlayingNow(
                              id: movie.movieId,
                              imagePath: movie.imagePath,
                              title: movie.title,
                              rating: movie.voteAverage,
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
