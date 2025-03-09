
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import '../models/schedule.model.dart';

class Util {
  static List<Schedule> parseTrainSchedule(String htmlString, String travelDay) {
    final Document document = parse(htmlString);
    final List<Schedule> trainSchedules = <Schedule>[];

    final List<Element> trainNodes = document.querySelectorAll('.bgMiddle');

    for (final Element trainNode in trainNodes) {
      final String? trainNo = trainNode.querySelector('td')?.text.trim();
      final Element? departNode = trainNode.nextElementSibling;
      final Element? arriveNode = departNode?.nextElementSibling;

      final String? departTime = departNode?.querySelector('td')?.nextElementSibling?.text.trim();
      final String? arriveTime = arriveNode?.querySelector('td')?.nextElementSibling?.text.trim();

      if (trainNo != null && departTime != null && arriveTime != null) {
        final Schedule schedule = Schedule(
          trainNo: trainNo,
          departTime: departTime.split('  ')[1].trim(),
          departStation: departTime.split('  ')[0].trim(),
          arriveTime: arriveTime.split('  ')[1].trim(),
          arriveStation: arriveTime.split('  ')[0].trim(),
          travelDay: travelDay,
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
        schedule1.arriveStation == schedule2.arriveStation &&
        schedule1.travelDay == schedule2.travelDay;
  }

  static bool containsSchedule(List<Schedule> schedules, Schedule schedule) {
    return schedules.any((Schedule s) => isSchedulesEqual(s, schedule));
  }
}