// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/actors_bloc/cubit.dart';
// import '../bloc/actors_bloc/cubit_state.dart';

// import '../widgets/common_itemTile.dart';

// class ActorsListPage extends StatefulWidget {
//   const ActorsListPage({Key? key}) : super(key: key);

//   @override
//   _ActorsListPageState createState() => _ActorsListPageState();
// }

// class _ActorsListPageState extends State<ActorsListPage>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: ActorsListViewBuilder(),
//     );
//   }
// }

// class ActorsListViewBuilder extends StatelessWidget {
//   const ActorsListViewBuilder({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ActorsCubit, ActorsState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         final _actorsBloc = BlocProvider.of<ActorsCubit>(context);

//         Future<Null> refreshPage() async {
//           _actorsBloc.refreshActors();
//           await Future.delayed(Duration(seconds: 2));
//         }

//         if (state is ActorsInitialState) {
//           _actorsBloc.getActors();
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is ActorsLoadedState) {
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
//                     itemCount: state.response!.items!.length,
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       var item = state.response!.items![index];
//                       return ItemListTile(
//                           title: item.title,
//                           description: item.description,
//                           imageUrl: item.enclosure!.url!);
//                     }),
//               ],
//             ),
//           );
//         } else if (state is ActorsLoadingState) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is ActorsErrorState) {
//           return Center(
//             child: Text(state.message),
//           );
//         } else {
//           return Center(
//             child: Text('message.message'),
//           );
//         }
//       },
//     );
//   }
// }
