import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';

class UserProfileImage extends StatelessWidget {
  final String image;

  const UserProfileImage({this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isNullEmptyOrWhitespace) {
      double size = MediaQuery.of(context).size.width * 0.60;
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.account_circle, color: Colors.white, size: size),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        height: MediaQuery.of(context).size.width * 0.60,
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(140.0),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            return SizedBox(
              width: 300.0,
              height: 300.0,
              child: Icon(Icons.account_circle, color: Colors.white, size: 300.0),
            );
          },
        ),
      );
    }
  }
}
