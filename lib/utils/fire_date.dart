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
