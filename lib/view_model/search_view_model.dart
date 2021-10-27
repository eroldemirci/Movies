import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../bloc/movies_detail_bloc/cubit.dart';
import '../bloc/movies_search_bloc/cubit.dart';
import '../bloc/movies_search_bloc/movies_search_state.dart';
import '../models/movies_searchResponse.dart';
import '../utils/colors.dart';

import '../utils/textStyles.dart';
import '../views/movie_detail_view.dart';
import '../widgets/custom_widgets.dart';

class SearchViewModel {
  Widget appBarTextField(MoviesSearchCubit _bloc) {
    TextEditingController searchController = TextEditingController();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20,),
      height: 60,
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          _bloc.searchMovie(value.trim(), 'tr-TR');
          if (value.length == 0) {
            _bloc.setValueState(true);
            _bloc.emit(MoviesSearchInitialState());
          } else {
            _bloc.setValueState(false);
          }
        },
        style: TextStyle(color: Colors.grey[850]),
        cursorColor: Colors.grey[850],
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              searchController.clear();
              _bloc.emit(MoviesSearchInitialState());
            },
            child: Icon(
              CupertinoIcons.clear,
              color: Colors.grey[850],
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            color: Colors.grey[850],
          ),
          hintText: 'Film Ara',
          hoverColor: Colors.grey[850],
          labelStyle: TextStyle(
            color: Colors.grey[850],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  AppBar searchAppBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    MoviesSearchCubit _bloc = BlocProvider.of<MoviesSearchCubit>(context);
    return AppBar(
      backgroundColor: appBarColor,
      title: appBarTextField(_bloc),
    );
  }

  Widget searchResultCard(BuildContext context, MoviesSearchLoadedState state,
      int index, Result? data) {
    DateFormat dateFormat = DateFormat.y();
    Size size = MediaQuery.of(context).size;
    String formatYear = '';
    if (data?.releaseDate != null && data?.releaseDate != "") {
      formatYear = dateFormat.format(DateTime.parse(data!.releaseDate!));
    }
    final _bloc = BlocProvider.of<MoviesDetailCubit>(context);
    return InkWell(
      onTap: () {
        _bloc.setMovieId(data!.id!);

        Get.to(MovieDetailView(
          imagePath: data.posterPath ?? null,
        ));
      },
      child: Container(
        height: 250,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CustomWidgets(context).listTileLeading(state, index),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        data?.title ?? '',
                        style: movieTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formatYear,
                      style: castCharacterStyle,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_outlined,
                          color: Colors.yellow[700],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data?.voteAverage! == 0
                              ? data!.voteAverage!.toStringAsFixed(0)
                              : data!.voteAverage!.toStringAsFixed(1),
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
