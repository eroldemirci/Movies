import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/auth_controller.dart';
import 'package:movies/utils/textStyles.dart';

class UserFavoriteCard extends StatelessWidget {
  const UserFavoriteCard(
      {Key? key, required this.favorites, required this.index})
      : super(key: key);

  final List? favorites;
  final int index;

  @override
  Widget build(BuildContext context) {
    AuthController favController = Get.find<AuthController>();
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
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      width: double.maxFinite,
                      imageUrl: 'https://image.tmdb.org/t/p/original' +
                          favorites?[index]['image_path'],
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
                    ),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
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
                            '${favorites?[index]['vote_average'].toStringAsFixed(1) ?? '0'}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Text(
                          '${favorites?[index]['title'] ?? ''}',
                          style: bodyText,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: InkWell(
            onTap: () {
              favController.removeFavorite(
                favorites?[index]['id'] ?? 0,
                favorites?[index]['vote_average'] ?? 0,
                favorites?[index]['title'] ?? '',
                favorites?[index]['image_path'] ?? '',
              );
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
        )
      ],
    );
  }
}
