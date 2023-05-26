import 'package:flutter/material.dart';
export './popup_main.dart';
export './model.dart';

class DetailScreenImg extends StatelessWidget {
  const DetailScreenImg({super.key, required this.url, this.type = 'network'});
  final dynamic url;
  final String? type;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Hero(
          tag: 'imageHero',
          child: type == 'memory'
              ? Image.memory(url)
              : Image.network(
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
