import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/bloc/movies_detail_bloc/movie_detail_state.dart';
import 'package:movies/bloc/movies_search_bloc/movies_search_state.dart';
import 'package:movies/database/controller.dart';
import 'package:movies/models/movies_detail.dart';
import 'package:movies/utils/servide_urls.dart';
import 'package:movies/utils/textStyles.dart';

class CustomWidgets {
  CustomWidgets(this.context);

  BuildContext context;
  Center loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget listTileLeading(MoviesSearchLoadedState state, int index) {
    Size size = MediaQuery.of(context).size;
    var imagePath = state.searchResponse?.results?[index]?.posterPath;
    return imagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: IMAGE_BASEURL + imagePath,
              height:
                  size.width <= 480 ? size.height * 0.19 : size.height * 0.28,
              width: size.width <= 480 ? 80 : 80,
              fit: BoxFit.fill,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: size.width <= 480 ? size.height * 1.8 : size.height * 2.2,
              width: 80,
              color: Colors.grey[850],
              child: Icon(
                CupertinoIcons.film,
                color: Colors.blue,
              ),
            ),
          );
  }

  Widget addToWatchListButton(
      FavoriteController _controller, MoviesDetail movie) {
    if (_controller.movieIds.value.contains(movie.id)) {
      return InkWell(
        onTap: () {
          _controller.deleteFavorite(movie.id);
        },
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(Icons.done, color: Colors.white),
              Text(
                'İzleme Listende',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          _controller.addFavorite(movie.id!, movie.title!,
              movie.posterPath ?? '', movie.voteAverage ?? 0);
        },
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.blue),
              Text(
                'İzleme Listene Ekle',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Text tumunuGorText() => Text(
        'Tümünü Gör',
        style: tumunuGorTextStyle,
      );

  Widget customCastCard(
      String? imageUrl, String? actorName, String? characterName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 120,
        height: 200,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        width: 120,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://image.tmdb.org/t/p/original' + imageUrl,
                        errorWidget: (a, b, c) {
                          return Container();
                        },
                      )
                    : Container(
                        width: 120,
                        color: Colors.grey[850],
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[850],
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: Column(
                    children: [
                      Text(
                        actorName ?? '',
                        style: castNameStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        characterName ?? '',
                        style: castCharacterStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget directorRow(MoviesDetailLoadedState state) {
    List<String?> directorsList = [];
    directorsList.clear();
    if (state.responseCast?.crew != null) {
      for (var i = 0; i < state.responseCast!.crew!.length; i++) {
        if (state.responseCast?.crew?[i].job == 'Director') {
          directorsList.add(state.responseCast?.crew?[i].name ?? '');
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Yönetmen  ',
              style: castNameStyle,
            ),
            Text(
              directorsList.length != 0 ? directorsList[0]! : '',
              style: castCharacterStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget photoGalleryRow(
      BuildContext context, MoviesDetailLoadedState state, String baslik) {
    if (state.responseImages!.backdrops!.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    baslik,
                    style: titleStyle,
                  ),
                  tumunuGorText()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              photoGalleryListView(state),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget photoGalleryListView(MoviesDetailLoadedState state) => Container(
        height: 150,
        child: ListView.separated(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: state.responseImages!.backdrops!.length >= 20
              ? 20
              : state.responseImages!.backdrops!.length,
          itemBuilder: (context, index) {
            String imagePath =
                state.responseImages!.backdrops![index].filePath!;
            return Container(
              height: 150,
              width: 150,
              child: Hero(
                tag: state.responseImages!.id!.toString(),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: IMAGE_BASEURL + imagePath,
                      fit: BoxFit.fill,
                    )),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
        ),
      );
}
