import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  const Cell({super.key, required this.text, required this.onTap});
  final String text;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          width: 230,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 235, 235, 235)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 161, 161, 161)),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color.fromARGB(255, 151, 151, 151),
              )
            ],
          ),
        ));
  }
}
