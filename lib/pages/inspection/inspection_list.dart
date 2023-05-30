import 'package:fire_control_app/pages/inspection/inspection_card.dart';
import 'package:fire_control_app/pages/inspection/route_detail_page.dart';
import 'package:fire_control_app/pages/inspection/task_detail_page.dart';
import 'package:fire_control_app/pages/inspection/inspection_filter.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/common/global.dart';

/// 任务列表
class PlanList extends StatelessWidget {

  final int? _userId;

  final TaskParam _taskParam;

  PlanList({super.key}) : _userId = Global.profile.userId, _taskParam = TaskParam();

  @override
  Widget build(BuildContext context) {
    return LoadList<TaskApi, TaskParam, TaskItem>(
      api: TaskApi(),
      param: _taskParam,
      toolbarBuilder: _buildToolbar,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['执行中', '已完成', '未完成'],
                height: 30,
                onTap: (index) {
                  _taskParam.status = index + 1;
                  _taskParam.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style:
              const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            ),
            TaskFilter(param: _taskParam,)
          ],
        ));
  }

  Widget _buildItem(BuildContext context, TaskItem item, int index) {
    return GestureDetector(
      onTap: () {
        if (_taskParam.status == 1 && _userId != item?.userId) {
          Message.show('无法执行，这不是您的任务');
          return;
        }
        Navigator.pushNamed(context, TaskDetailPage.routeName,
            arguments: item.taskId);
      },
      child: TaskCard(item: item, executing: _taskParam.status == 1),
    );
  }
}

/// 路线列表
class RouteList extends StatelessWidget {
  final RouteParam _routeParam;

  RouteList({super.key}) : _routeParam = RouteParam();

  @override
  Widget build(BuildContext context) {
    return LoadList<RouteApi, RouteParam, RouteItem>(
      api: RouteApi(),
      param: _routeParam,
      toolbarBuilder: _buildToolbar,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['可领取', '已领取'],
                height: 30,
                onTap: (index) {
                  if (index == 1) {
                    _routeParam.status = 2;
                  } else {
                    _routeParam.status = 1;
                  }
                  _routeParam.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            ),
            RouteFilter(
              param: _routeParam,
            )
          ],
        ));
  }

  Widget _buildItem(BuildContext context, RouteItem item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteDetailPage.routeName,
            arguments: item.taskId);
      },
      child: RouteCard(
        item: item,
        isList: true,
      ),
    );
  }
}