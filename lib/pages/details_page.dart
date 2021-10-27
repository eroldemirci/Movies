import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class DetailSelectedItem extends StatelessWidget {
  DetailSelectedItem({Key? key, this.title, this.description, this.imageUrl})
      : super(key: key);
  String? title;
  String? description;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(title!),
      ),
      body: detailBody(size),
    );
  }

  SafeArea detailBody(Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.5,
                    width: double.infinity,
                    child: imageUrl != null
                        ? Hero(
                            transitionOnUserGestures: true,
                            tag: title.toString(),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                ),
                                child: Icon(Icons.movie_creation_sharp),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Icon(Icons.person),
                              ),
                              fit: BoxFit.fill,
                              // height: size.height * 0.3,
                              // width: size.width * 1,
                            ),
                          )
                        : null,
                  ),
                  Html(
                    data: title!,
                    style: {'body': Style(color: Colors.blue)},
                  ),
                  Html(
                    data: description!,
                    style: {'body': Style(color: Colors.white)},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
