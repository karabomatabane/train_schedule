
import 'package:html/parser.dart' show parse;
import 'package:train_schedule/models/schedule.model.dart';

class Util {
  static List<Schedule> parseTrainSchedule(String htmlString) {
    var document = parse(htmlString);
    List<Schedule> trainSchedules = [];

    var trainNodes = document.querySelectorAll('.bgMiddle');

    for (var trainNode in trainNodes) {
      var trainNo = trainNode.querySelector('td')?.text.trim();
      var departNode = trainNode.nextElementSibling;
      var arriveNode = departNode?.nextElementSibling;

      var departTime = departNode?.querySelector('td')?.nextElementSibling?.text.trim();
      var arriveTime = arriveNode?.querySelector('td')?.nextElementSibling?.text.trim();

      if (trainNo != null && departTime != null && arriveTime != null) {
        final Schedule schedule = Schedule(
          trainNo: trainNo,
          departTime: departTime.split('  ')[1].trim(),
          departStation: departTime.split('  ')[0].trim(),
          arriveTime: arriveTime.split('  ')[1].trim(),
          arriveStation: arriveTime.split('  ')[0].trim(),
        );
        trainSchedules.add(schedule);
      }
    }
    return trainSchedules;
  }

  static bool isSchedulesEqual(Schedule schedule1, Schedule schedule2) {
    return schedule1.trainNo == schedule2.trainNo &&
        schedule1.departTime == schedule2.departTime &&
        schedule1.departStation == schedule2.departStation &&
        schedule1.arriveTime == schedule2.arriveTime &&
        schedule1.arriveStation == schedule2.arriveStation;
  }

  static bool containsSchedule(List<Schedule> schedules, Schedule schedule) {
    return schedules.any((s) => isSchedulesEqual(s, schedule));
  }
}