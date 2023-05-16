import 'package:flutter/material.dart';
export './popup_main.dart';
export './model.dart';

class DetailScreenImg extends StatelessWidget {
  const DetailScreenImg({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            url,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
