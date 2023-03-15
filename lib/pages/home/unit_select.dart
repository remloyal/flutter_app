import 'package:fire_control_app/states/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:provider/provider.dart';

class UnitSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UnitSelectState();
}

class _UnitSelectState extends State<UnitSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择单位"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              decoration:
                  InputDecoration(hintText: Global.profile.apiInfo.baseUrl),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [],
            ),
          ),
          Expanded(
            flex: 1,
            child: Consumer<UnitModel>(
                builder: (context, UnitModel unitModel, _) => Scrollbar(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: Colors.black),
                        itemCount: Global.units.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                              title: Text(Global.units[index].name),
                              onTap: () {
                                unitModel.unit = Global.units[index];
                                Navigator.of(context).pop();
                              },
                            )))),
          )
        ],
      ),
    );
  }
}
