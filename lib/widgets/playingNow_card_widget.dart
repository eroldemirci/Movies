import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/auth_controller.dart';
import 'package:movies/views/login_view.dart';
import '../database/controller.dart';

import '../utils/textStyles.dart';

class CardMoviesPlayingNow extends StatelessWidget {
  AuthController favController = Get.find<AuthController>();
  CardMoviesPlayingNow({
    Key? key,
    this.title,
    this.rating,
    this.imagePath,
    this.id,
  }) : super(key: key);
  final String? title;
  final int? id;
  final double? rating;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthController>(
      builder: (_control) {
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
                  Expanded(flex: 6, child: images(size)),
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: columnText(context),
                      )),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: FirebaseAuth.instance.currentUser?.uid == null
                  ? InkWell(
                      onTap: () {
                        if (id != null) {
                          Get.to(UserLoginView());
                        }
                      },
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
                    )
                  : !_control.userFavoriteIds.contains(id)
                      ? InkWell(
                          onTap: () {
                            if (id != null) {
                              _control.addFavorite(id ?? 0, rating ?? 0,
                                  title ?? '', imagePath ?? '');
                            }
                            print("$id" +
                                " Favorilere eklendi.  Filmin Adı : $title");
                          },
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
                        )
                      : InkWell(
                          onTap: () {
                            if (id != null) {
                              _control.removeFavorite(id ?? 0, rating ?? 0,
                                  title ?? '', imagePath ?? '');
                            }
                            print("$id" +
                                " Favorilere eklendi.  Filmin Adı : $title");
                          },
                          child: Container(
                            height: 40,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                        ),
            ),
          ],
        );
      },
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
}
