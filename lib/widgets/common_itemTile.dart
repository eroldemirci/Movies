import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:movies/pages/details_page.dart';

class ItemListTile extends StatelessWidget {
  ItemListTile({this.title, this.description, this.imageUrl});

  final String? title;
  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context)
        .primaryTextTheme
        .subtitle2!
        .copyWith(color: Colors.blue, fontSize: 18);

    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => Get.to(DetailSelectedItem(
        description: description,
        title: title,
        imageUrl: imageUrl,
      )),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: imageUrl != null
                  ? Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: title.toString(),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl!,
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
                            height: size.height * 0.3,
                            width: size.width * 0.07,
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Icon(Icons.video_camera_front_outlined),
                      ),
                    ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Text(
                    title!,
                    style: titleStyle,
                  ),
                  Html(
                    data: description!,
                    style: {
                      'body': Style(
                          color: Colors.white,
                          maxLines: 3,
                          backgroundColor: Theme.of(context).backgroundColor,
                          textOverflow: TextOverflow.ellipsis),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
