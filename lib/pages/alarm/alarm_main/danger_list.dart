import 'package:flutter/material.dart';

class DangerList extends StatefulWidget {
  const DangerList({Key? key}) : super(key: key);

  @override
  State<DangerList> createState() => _DangerListState();
}

class _DangerListState extends State<DangerList> {
  @override
  Widget build(BuildContext context) {
    return const Text('危险品');
  }
}
