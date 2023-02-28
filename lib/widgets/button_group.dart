import 'package:flutter/material.dart';

class ButtonGroup extends StatefulWidget {

  final ValueChanged<int>? onTap;

  final List<String> names;

  final double? height;

  ButtonGroup({super.key, required this.names, this.onTap, this.height});

  @override
  State<StatefulWidget> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  List<bool> _selected = [];

  @override
  void initState() {
    _selected = widget.names.map((e) => false).toList();
    _selected[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: widget.height ?? 40,
      child: ToggleButtons(
        isSelected: _selected,
        onPressed: (index) {
          for (int i = 0; i < _selected.length; i++) {
            _selected[i] = false;
            if (i == index) _selected[i] = true;
          }
          widget.onTap != null ? widget.onTap!(index) : null;
          setState(() { });
        },
        borderRadius: BorderRadius.circular(5),
        children: widget.names.map((e) => Padding(
            padding: const EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
            child: Text(e)
        )).toList(),
      ),
    );
  }
}