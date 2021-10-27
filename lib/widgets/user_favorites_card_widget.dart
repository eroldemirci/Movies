import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/auth_controller.dart';
import 'package:movies/utils/textStyles.dart';

class UserFavoriteMoviesCard extends GetWidget<AuthController> {
 const UserFavoriteMoviesCard({this.imagePath, this.title, this.rating, this.movieId, Key? key}) : super(key: key);
  final int? movieId;
  final String? imagePath;
  final String? title;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: 120,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.3),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900]),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Text('$movieId'),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget images(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      child: imagePath != null
          ? CachedNetworkImage(
              width: double.maxFinite,
              imageUrl: 'https://image.tmdb.org/t/p/original' + imagePath!,
              filterQuality: FilterQuality.high,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                ),
                child: Icon(
                  CupertinoIcons.film,
                  color: Colors.blue,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Icon(Icons.person),
              ),
              fit: BoxFit.fill,
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: Icon(
                CupertinoIcons.film,
                color: Colors.blue,
              ),
            ),
    );
  }

  Widget columnText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        movieRateRow(context),
        SizedBox(
          height: 10,
        ),
        movieTitleRow,
      ],
    );
  }

  Widget get movieTitleRow => Flexible(
        child: Text(
          title ?? '',
          style: bodyText,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
      );

  Widget movieRateRow(BuildContext context) => Flexible(
        child: Row(
          children: [
            Icon(
              Icons.star_outlined,
              color: Colors.yellow[700],
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '${(rating?.toStringAsFixed(1)) ?? '0'}',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
}
