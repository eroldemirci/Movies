// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:webfeed/domain/rss_item.dart';

// import '../bloc/series_bloc/cubit.dart';
// import '../bloc/series_bloc/cubit_state.dart';

// import '../widgets/common_itemTile.dart';

// class SeriesListPage extends StatefulWidget {
//   const SeriesListPage({Key? key}) : super(key: key);

//   @override
//   _SeriesListPageState createState() => _SeriesListPageState();
// }

// class _SeriesListPageState extends State<SeriesListPage>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: SeriesListViewBuilder(),
//     );
//   }
// }

// class SeriesListViewBuilder extends StatelessWidget {
//   const SeriesListViewBuilder({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SeriesCubit, SeriesState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         final _seriesBloc = BlocProvider.of<SeriesCubit>(context);

//         Future<Null> refreshPage() async {
//           _seriesBloc.refreshSeries();
//           await Future.delayed(Duration(seconds: 2));
//         }

//         if (state is SeriesInitialState) {
//           _seriesBloc.getSeries();
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is SeriesLoadedState) {
//           return RefreshIndicator(
//             onRefresh: refreshPage,
//             child: ListView(
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               children: [
//                 ListView.separated(
//                     separatorBuilder: (context, index) => Divider(
//                           color: Colors.blue,
//                         ),
//                     itemCount: state.response.items!.length,
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       RssItem item = state.response.items![index];
//                       return ItemListTile(
//                           title: item.title!,
//                           description: item.description!,
//                           imageUrl: item.enclosure != null
//                               ? item.enclosure!.url
//                               : null);
//                     }),
//               ],
//             ),
//           );
//         } else if (state is SeriesLoadingState) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is SeriesErrorState) {
//           return Center(
//             child: Text(state.message),
//           );
//         } else {
//           final message = state as SeriesErrorState;
//           return Center(
//             child: Text(
//               message.message,
//             ),
//           );
//         }
//       },
//     );
//   }
// }
