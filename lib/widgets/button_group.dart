import 'package:flutter/material.dart';

class ButtonGroup extends StatefulWidget {
  final ValueChanged<int>? onTap;

  final List<String> names;

  final double? height;

  const ButtonGroup({super.key, required this.names, this.onTap, this.height});

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
    return SizedBox(
      height: widget.height ?? 40,
      child: ToggleButtons(
        isSelected: _selected,
        selectedColor: Colors.red,
        selectedBorderColor: Colors.red,
        fillColor: const Color(0xffFFEBEE),
        onPressed: (index) {
          for (int i = 0; i < _selected.length; i++) {
            _selected[i] = false;
            if (i == index) _selected[i] = true;
          }
          widget.onTap != null ? widget.onTap!(index) : null;
          setState(() {});
        },
        borderRadius: BorderRadius.circular(5),
        children: widget.names
            .map((e) => Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 0, right: 10, bottom: 0),
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 14),
                )))
            .toList(),
      ),
    );
  }
}

class ButtonBarState extends StatefulWidget {
  const ButtonBarState(
      {super.key, required this.names, required this.onTap, this.index});
  final List<Map<dynamic, dynamic>> names;
  final ValueChanged<String> onTap;
  final String? index;
  @override
  State<ButtonBarState> createState() => _ButtonBarStateState();
}

class _ButtonBarStateState extends State<ButtonBarState> {
  late String _selectedIndex = '0';
  @override
  void initState() {
    if (widget.index != null) {
      _selectedIndex = widget.index as String;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        spacing: 8,
        children: widget.names.map((e) {
          return TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  _selectedIndex == e['value']
                      ? Colors.red
                      : const Color.fromARGB(255, 0, 0, 0)),
              backgroundColor: MaterialStateProperty.all(
                  _selectedIndex == e['value']
                      ? const Color.fromARGB(255, 255, 227, 225)
                      : const Color.fromARGB(255, 250, 250, 250)),
              side: MaterialStateProperty.all(BorderSide(
                  color: _selectedIndex == e['value']
                      ? Colors.red
                      : const Color.fromARGB(255, 201, 201, 201),
                  width: 1)),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 12, color: Colors.red)),
              minimumSize: MaterialStateProperty.all(const Size(50, 15)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = e['value'];
                widget.onTap(_selectedIndex);
              });
            },
            child: Text(e['text']),
          );
        }).toList(),
      ),
    );
  }
}
