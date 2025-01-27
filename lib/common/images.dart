import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:divoc/services/utils.dart';

class UploadedImageFullScreen extends StatelessWidget {
  final String title;
  final String image;

  const UploadedImageFullScreen({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(0),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            return Container();
          },
        ),
      ),
    );
  }
}

class UploadedImage extends StatelessWidget {
  final String image;

  const UploadedImage({this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isNullEmptyOrWhitespace) {
      return Container();
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.width * 0.90,
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            return Container();
          },
        ),
      );
    }
  }
}

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

class UserProfileSmallImage extends StatelessWidget {
  final String image;

  const UserProfileSmallImage({this.image});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.30;
    if (image.isNullEmptyOrWhitespace) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.account_circle, color: Colors.white, size: size),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
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
              width: size,
              height: size,
              child: Icon(Icons.account_circle, color: Colors.white, size: 300.0),
            );
          },
        ),
      );
    }
  }
}
