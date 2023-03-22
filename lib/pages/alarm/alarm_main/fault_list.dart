import 'package:flutter/material.dart';

class FaultList extends StatefulWidget {
  const FaultList({Key? key}) : super(key: key);

  @override
  State<FaultList> createState() => _FaultListState();
}

class _FaultListState extends State<FaultList> {
  @override
  Widget build(BuildContext context) {
    return const Text('故障');
  }
}
