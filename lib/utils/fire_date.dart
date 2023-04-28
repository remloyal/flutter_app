formatDurationByStart(String oldTime) {
  var specificDate = oldTime.split(' ');
  var specific = specificDate[0].split('-');
  var time = specificDate[1].split(':');
  DateTime startDate = DateTime(
    int.parse(specific[0]),
    int.parse(specific[1]),
    int.parse(specific[2]),
    int.parse(time[0]),
    int.parse(time[1]),
    int.parse(time[2]),
  );
  DateTime endDate = DateTime.now();
  var difference = endDate.difference(startDate);
  var hours = difference.inHours;
  var minutes = difference.inMinutes - difference.inHours * 60;
  var seconds = difference.inSeconds - difference.inMinutes * 60;

  if (difference.inDays > 0) {
    hours = difference.inHours - difference.inDays * 24;
    return '${difference.inDays}天$hours时$minutes分$seconds秒';
  } else {
    return '$hours时$minutes分$seconds秒';
  }
}

format(String moment) {
  var specificDate = moment.split(' ');
  var specific = specificDate[0].split('-');
  var time = specificDate[1].split(':');
  DateTime dateTime = DateTime(
    int.parse(specific[0]),
    int.parse(specific[1]),
    int.parse(specific[2]),
    int.parse(time[0]),
    int.parse(time[1]),
    int.parse(time[2]),
  );
  return dateTime;
}

/// 两个时间间隔的格式化
/// 格式：
///    默认：xx天xx时xx分xx秒
///    1：天大于0，则不显示秒
formatDuration(start, end) {
  var startTime = format(start);
  var endTime = format(end);
  var difference = endTime.difference(startTime);
  var hours = difference.inHours;
  var minutes = difference.inMinutes - difference.inHours * 60;
  var seconds = difference.inSeconds - difference.inMinutes * 60;

  if (difference.inDays > 0) {
    hours = difference.inHours - difference.inDays * 24;
    return '${difference.inDays}天$hours时$minutes分$seconds秒';
  }
  if (difference.inHours > 0) {
    return '$hours时$minutes分$seconds秒';
  }
  if (difference.inMinutes > 0) {
    return '$minutes分$seconds秒';
  }
  if (difference.inSeconds >= 0) {
    return '$seconds秒';
  }
  return '';
}

formatTime(time) {
  var date = DateTime.fromMillisecondsSinceEpoch(time);
  return date;
}
