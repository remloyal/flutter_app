import 'dart:ui';

import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double getScreenWidth() {
  return window.physicalSize.width / window.devicePixelRatio;
}

double getScreenHeight() {
  return window.physicalSize.height / window.devicePixelRatio;
}

class FilterDialog extends StatefulWidget {
  // 占屏幕宽度得百分比，默认0.6
  final double ratio;

  final Widget? body;

  const FilterDialog({super.key, this.body, this.ratio = 0.7});

  @override
  State<StatefulWidget> createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog>
    with SingleTickerProviderStateMixin {
  late double _width;
  late AnimationController _controller;
  late Animation<RelativeRect> _animation;

  @override
  void initState() {
    super.initState();
    _width = getScreenWidth() * widget.ratio;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    final CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _animation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(_width, 0, -_width, 0),
            end: const RelativeRect.fromLTRB(0, 0, 0, 0))
        .animate(curve);
    _controller.forward();
  }

  ///关闭页面动画
  closeModel() async {
    await _controller.reverse();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("build filter");
    double left = getScreenWidth() - _width;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: getScreenWidth(),
              height: getScreenHeight(),
            ),
            onTap: () => closeModel(),
          ),
          Positioned(
            left: left,
            top: 0,
            child: SizedBox(
              width: _width,
              height: getScreenHeight(),
              child: Stack(
                children: [
                  PositionedTransition(
                    rect: _animation,
                    child: Container(
                      color: Colors.white,
                      width: _width,
                      height: getScreenHeight(),
                      child: widget.body,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

abstract class FilterItem extends StatefulWidget {
  final FilterController controller;

  final String? title;

  const FilterItem({super.key, required this.controller, this.title});
}

abstract class FilterItemState<T extends FilterItem> extends State<T> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(refresh);
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController _searchController;

  final String? hintText;

  final String? text;

  final ValueChanged<String>? onChanged;

  SearchTextField({super.key, this.onChanged, this.hintText, this.text})
      : _searchController = TextEditingController()
          ..text = text ?? ''
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: (text ?? '').length));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 12, color: FcColor.filterSelected),
        scrollPadding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: InputDecoration(
            filled: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            border: const OutlineInputBorder(),
            hintText: hintText ?? '请输入内容',
            hintStyle: const TextStyle(color: FcColor.filterHint)),
        onChanged: onChanged,
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  // 默认提示文字
  final String? hintText;

  // 选中的文字
  final String? text;

  final VoidCallback onPress;

  final IconData? iconData;

  final bool showForward;

  const SelectButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.iconData,
      this.showForward = false,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
          onTap: onPress,
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
            decoration: const BoxDecoration(color: FcColor.baseF5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (iconData != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      iconData,
                      size: 18,
                      color: FcColor.filterSelected,
                    ),
                  ),
                Expanded(
                  child: Text(
                    text ?? hintText ?? '',
                    maxLines: null, // 允许自动换行
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12,
                        color: (text != null)
                            ? FcColor.filterSelected
                            : FcColor.filterHint),
                  ),
                ),
                if (showForward)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: FcColor.filterSelected,
                  )
              ],
            ),
          )),
    );
  }
}

/// 点击弹出底部选择框
class BottomPickerFilterItem extends FilterItem {
  final int? selected;

  final List<String> items;

  final String? hintText;

  final ValueChanged<int> onConfirm;

  final bool search;

  const BottomPickerFilterItem(
      {super.key,
      super.title,
      required super.controller,
      this.selected,
      required this.items,
      this.hintText,
      required this.onConfirm,
      this.search = false});

  @override
  State<StatefulWidget> createState() => _BottomPickerFilterItemState();
}

class _BottomPickerFilterItemState
    extends FilterItemState<BottomPickerFilterItem> {
  late FixedExtentScrollController _controller;

  String? _text;

  late int _selected;

  late List<String> _items;

  late StateSetter _pickerSetter;

  @override
  void initState() {
    _items = widget.items;
    _selected = widget.selected ?? 0;
    _text = widget.selected != null ? widget.items[_selected] : null;
    super.initState();
  }

  @override
  void refresh() {
    _selected = 0;
    _text = null;
    super.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(
          title: widget.title ?? '',
        ),
        SelectButton(
          hintText: widget.hintText,
          text: _text,
          onPress: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => _buildPicker(context)).then((value) {
              if (value != null) {
                int index = widget.items.indexOf(_items[value]);
                _text = _items[value];
                _selected = index;
                widget.onConfirm(index);
                setState(() {});
              }
              _items = widget.items;
            });
          },
          showForward: true,
        )
      ],
    );
  }

  Widget _buildPicker(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double pickerHeight = widget.search ? 420.0 : 300;
    _controller = FixedExtentScrollController(initialItem: _selected);
    return Container(
      height: pickerHeight,
      padding: const EdgeInsets.all(10),
      width: data.size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, _controller.selectedItem);
                },
                child: const Text(
                  "确认",
                  style: TextStyle(color: FcColor.info),
                ),
              ),
            ],
          ),
          if (widget.search)
            CupertinoSearchTextField(
              placeholder: '请输入搜索关键词',
              onSubmitted: _changePicker,
              onChanged: _searchTextChange,
            ),
          Expanded(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                _pickerSetter = stateSetter;
                return CupertinoPicker(
                  scrollController: _controller,
                  itemExtent: 50, //行高
                  onSelectedItemChanged: (value) {},
                  children: _items.map((data) {
                    return Center(
                      child: Text(
                        data,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _changePicker(String value) {
    _items = widget.items
        .where((element) => element.contains(value))
        .toList(growable: false);
    _pickerSetter(() {});
  }

  void _searchTextChange(String value) {
    if (value.isEmpty) {
      _items = widget.items;
      _pickerSetter(() {});
    }
  }
}

/// 搜索
class KeywordFilterItem extends FilterItem {
  final String? hintText;

  final KeywordParam param;

  const KeywordFilterItem(
      {super.key,
      super.title,
      required super.controller,
      this.hintText,
      required this.param});

  @override
  State<StatefulWidget> createState() => _KeywordFilterItemState();
}

class _KeywordFilterItemState extends FilterItemState<KeywordFilterItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardHeader(
          title: widget.title ?? '搜索',
        ),
        SearchTextField(
          hintText: widget.hintText,
          text: widget.param.keyword,
          onChanged: (value) {
            widget.param.keyword = value;
          },
        )
      ],
    );
  }
}

/// 起止时间
class DateTimeFilterItem extends FilterItem {
  final TimeParam param;

  const DateTimeFilterItem(
      {super.key, super.title, required super.controller, required this.param});

  @override
  State<StatefulWidget> createState() => _DateTimeFilterItemState();
}

class _DateTimeFilterItemState extends FilterItemState<DateTimeFilterItem> {

  @override
  Widget build(BuildContext context) {
    String? text;
    String? beginTime = widget.param.beginTime;
    String? endTime = widget.param.endTime;
    if (beginTime != null && endTime != null) {
      text = '$beginTime 至 $endTime';
    }
    return Column(
      children: [
        CardHeader(
          title: widget.title ?? '起止时间',
          tail: (widget.param.beginTime != null)
              ? GestureDetector(
                  onTap: () {
                    widget.param.beginTime = null;
                    widget.param.endTime = null;
                    setState(() {});
                  },
                  child: const Text(
                    '清除',
                    style: TextStyle(fontSize: 12, color: FcColor.warn),
                  ),
                )
              : null,
        ),
        SelectButton(
          iconData: Icons.calendar_month,
          hintText: '选择起止日期',
          text: text,
          onPress: () {
            DateTime end = DateTime.now();
            DateTime start = DateTime(end.year - 10);
            DateTimeRange? defaultRange;
            DateFormat format = DateFormat('yyyy-MM-dd');

            if (beginTime != null && endTime != null) {
              defaultRange = DateTimeRange(
                  start: format.parse(beginTime), end: format.parse(endTime));
            }
            showDateRangePicker(
                    context: context,
                    firstDate: start,
                    lastDate: end,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDateRange: defaultRange)
                .then((value) {
              if (value != null) {
                DateFormat format = DateFormat('yyyy-MM-dd');
                DateTimeRange range = value;
                widget.param.beginTime = format.format(range.start);
                widget.param.endTime = format.format(range.end);
                setState(() {});
              }
            });
          },
        )
      ],
    );
  }
}

/// 按钮组
class ButtonsFilterItem extends FilterItem {
  final int? selected;

  final ValueChanged<int>? onTap;

  final List<String> items;

  const ButtonsFilterItem(
      {super.key,
      super.title,
      required super.controller,
      this.selected,
      this.items = const <String>[],
      this.onTap});

  @override
  State<StatefulWidget> createState() => _ButtonsFilterItemState();
}

class _ButtonsFilterItemState extends FilterItemState<ButtonsFilterItem> {
  int? _selected;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  @override
  void refresh() {
    super.refresh();
    _selected = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardHeader(
          title: widget.title ?? '',
        ),
        SpaceRadioButtons(
            selected: _selected,
            names: widget.items,
            onTap: (index) {
              _selected = index;
              if (widget.onTap != null) {
                widget.onTap!(index);
              }
              setState(() {});
            }),
      ],
    );
  }
}
