import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:movies/bloc/movies_detail_bloc/cubit.dart';
import 'package:movies/bloc/movies_detail_bloc/movie_detail_state.dart';
import 'package:movies/database/controller.dart';
import 'package:movies/models/movies_cast.dart';
import 'package:movies/models/movies_detail.dart';
import 'package:movies/utils/colors.dart';
import 'package:movies/utils/textStyles.dart';
import 'package:movies/widgets/custom_widgets.dart';
import 'package:movies/widgets/playingNow_card_widget.dart';

class MovieDetailView extends StatefulWidget {
  const MovieDetailView({Key? key, this.imagePath}) : super(key: key);
  final String? imagePath;

  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  Size? size;
  FavoriteController controller = Get.find<FavoriteController>();
  @override
  void initState() {
    super.initState();
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);
    _bloc.getMovieDetail(_bloc.movieID!, 'tr-TR');

    print('Detaya Girildi ' + _bloc.movieID.toString());
  }

  @override
  void dispose() {
    print('Sayfadan çıkıldı');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: BlocBuilder<MoviesDetailCubit, MoviesDetailState>(
        builder: (context, state) {
          if (state is MoviesDetailInitialState) {
            return loadingIndicator();
          } else if (state is MoviesDetailLoadingState) {
            return loadingIndicator();
          } else if (state is MoviesDetailLoadedState) {
            return buildScreen(context, state);
          } else if (state is MoviesDetailErrorState) {
            print(state.message);
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Center(
                child: Text(
                  " Beklenmedik Bir Hata Oluştu ",
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildScreen(BuildContext context, MoviesDetailLoadedState state) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: buildAppBar(context, state),
      body: buildBody(context, state),
    );
  }

  AppBar buildAppBar(BuildContext context, MoviesDetailLoadedState state) {
    return AppBar(
      backgroundColor: appBarColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        (state.response?.originalTitle) ?? '',
        style: titleStyle,
      ),
    );
  }

  Widget buildBody(BuildContext context, MoviesDetailLoadedState state) {
    CustomWidgets customWidget = CustomWidgets(context);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          titleRow(state),
          sliderRow(context, state),
          ratingRow(state),
          overWievRow(state),
          customWidget.directorRow(state),
          castRow(context, state, 'Oyuncular'),
          // customWidget.photoGalleryRow(context, state, 'Foto Galeri'),
          similiarMoviesRow(context, state, 'Benzer Filmler')
        ],
      ),
    );
  }

  Widget titleRow(
    MoviesDetailLoadedState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            state.response?.title ?? '',
            style: titleBigStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateAndMinuteRow(state),
              GetBuilder<FavoriteController>(
                builder: (_controller) {
                  return CustomWidgets(context).addToWatchListButton(
                      _controller, state.response ?? MoviesDetail());
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget sliderRow(BuildContext context, MoviesDetailLoadedState state) {
    if (state.responseImages?.backdrops != null) {
      return Container(
        child: CarouselSlider.builder(
          itemCount: state.responseImages!.backdrops!.length >= 10
              ? 10
              : state.responseImages!.backdrops!.length,
          itemBuilder: (context, index, int) {
            String imageUrl =
                (state.responseImages?.backdrops?[index].filePath) ?? 'null';

            return Stack(
              children: [sliderImage(imageUrl), imageShadow()],
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: false,
            autoPlayInterval: Duration(seconds: 6),
            autoPlayAnimationDuration: Duration(milliseconds: 200),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget ratingRow(MoviesDetailLoadedState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star_outlined,
                  color: Colors.yellow[700],
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          // state.response!.voteAverage!.toString(),
                          state.response?.voteAverage.toString() ?? '0',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '/10',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(state.response?.voteCount.toString() ?? '0',
                        style: TextStyle(color: Colors.white60, fontSize: 14)),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(child: genres(context, state)),
          ],
        ),
      ),
    );
  }

  Widget overWievRow(MoviesDetailLoadedState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.imagePath != null && widget.imagePath != ''
                  ? CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      imageUrl: 'https://image.tmdb.org/t/p/original' +
                          widget.imagePath!,
                      errorWidget: (a, b, c) {
                        return Container();
                      },
                      height: 200,
                      width: 120,
                      fit: BoxFit.fill)
                  : Container(
                      height: 200,
                      width: 120,
                      color: Colors.grey[850],
                      child: Center(
                        child: Icon(
                          CupertinoIcons.film,
                          color: Colors.blue,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                  state.response?.overview == null &&
                          state.response?.overview == ""
                      ? 'Açıklama bulunmamakta'
                      : "${state.response?.overview}",
                  maxLines: 12,
                  style: bodyText,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }

  Widget castRow(
      BuildContext context, MoviesDetailLoadedState state, String? baslik) {
    if (state.responseCast?.cast?.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    baslik ?? '',
                    style: titleStyle,
                  ),
                  CustomWidgets(context).tumunuGorText()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              castList(context, state),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget similiarMoviesRow(
      BuildContext context, MoviesDetailLoadedState state, String? baslik) {
    if (state.responseSimiliar?.results?.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    baslik ?? '',
                    style: titleStyle,
                  ),
                  CustomWidgets(context).tumunuGorText()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              similiarMoviesList(context, state),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget similiarMoviesList(
      BuildContext context, MoviesDetailLoadedState state) {
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);

    return Container(
      height: 250,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: state.responseSimiliar!.results!.length >= 10
              ? 10
              : state.responseSimiliar!.results!.length,
          physics: BouncingScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
          itemBuilder: (context, index) {
            var movie;
            if (state.responseSimiliar?.results?[index] != null) {
              movie = state.responseSimiliar!.results![index];
            }

            return InkWell(
              onTap: () {
                _bloc.setMovieId(movie.id);
                print('Detay sayfasından Detaya tıklandı  MovieId = ' +
                    movie.id.toString());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetailView(
                              imagePath: movie.posterPath,
                            )));
              },
              child: CardMoviesPlayingNow(
                id: movie.id,
                title: movie.title ?? '',
                imagePath: movie.posterPath ?? '',
                rating: movie.voteAverage ?? '',
              ),
            );
          }),
    );
  }

  Widget castList(BuildContext context, MoviesDetailLoadedState state) {
    if (state.responseCast?.cast != null) {
      return Container(
        height: 250,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: state.responseCast!.cast!.length >= 10
              ? 10
              : state.responseCast!.cast!.length,
          itemBuilder: (context, index) {
            Cast? cast;
            if (state.responseCast?.cast?[index] != null) {
              cast = state.responseCast!.cast![index];
              return CustomWidgets(context).customCastCard(
                  cast.profilePath ?? '',
                  cast.name ?? '',
                  cast.character ?? '');
            } else {
              return Container();
            }
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget genres(BuildContext context, MoviesDetailLoadedState state) {
    if (state.response?.genres != null) {
      return ListView.separated(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: state.response!.genres!.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 5,
            );
          },
          itemBuilder: (context, index) {
            return Container(
              height: 25,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                state.response?.genres?[index]?.name ?? '',
                style: bodyText,
              ),
            );
          });
    } else {
      return Container();
    }
  }

  Container imageShadow() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1],
      )),
    );
  }

  Widget sliderImage(String imageUrl) {
    if (imageUrl != 'null') {
      return CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/original' + imageUrl,
        fit: BoxFit.cover,
      );
    } else
      return Container();
  }

  Widget dateAndMinuteRow(MoviesDetailLoadedState? state) {
    if (state?.response?.releaseDate != null &&
        state?.response?.releaseDate != "") {
      DateFormat dateFormat = DateFormat.y();
      String formatYear = '';
      formatYear =
          dateFormat.format(state?.response?.releaseDate ?? DateTime(2020));

      return Row(
        children: [
          Text(
            formatYear,
            style: subBodyText,
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            state?.response?.runtime == null
                ? ('000' + ' dk')
                : '${state?.response?.runtime} dk',
            style: subBodyText,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "",
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            state?.response?.runtime == null
                ? ('000' + ' dk')
                : '${state?.response?.runtime} dk',
            style: subBodyText,
          ),
        ],
      );
    }
  }

  errorDialog(BuildContext context, MoviesDetailErrorState state) {
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
