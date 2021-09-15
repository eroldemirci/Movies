import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_search_bloc/cubit.dart';
import 'package:movies/bloc/movies_search_bloc/movies_search_state.dart';
import 'package:movies/models/movies_searchResponse.dart';

import 'package:movies/utils/textStyles.dart';
import 'package:movies/view_model/search_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchViewModel().searchAppBar(context),
      body: BlocBuilder<MoviesSearchCubit, MoviesSearchState>(
        builder: (context, state) {
          if (state is MoviesSearchInitialState) {
            return Center(
              child: Text(
                'Aradığınız Filmi Girebilirsiniz',
                style: titleStyle,
              ),
            );
          } else if (state is MoviesSearchLoadingState) {
          } else if (state is MoviesSearchLoadedState) {
            return buildBody(context, state);
          } else if (state is MoviesSearchErrorState) {
            return Center(
              child: Text(
                state.message,
                style: titleStyle,
              ),
            );
          }
          return Center();
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, MoviesSearchLoadedState state) {
    return Container(
      child: state.searchResponse!.results!.length != 0
          ? ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: state.searchResponse!.results!.length,
              itemBuilder: (context, index) {
                Result? data = state.searchResponse?.results?[index];
                return SearchViewModel()
                    .searchResultCard(context, state, index, data);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
            )
          : Center(
              child: Text(
                'Aradığınız sonuç bulunamadı',
                style: titleStyle,
              ),
            ),
    );
  }
}
