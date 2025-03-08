class ScheduleFormData {
  final int departStation;
  final int arriveStation;
  final String travelDay;
  final String searchTime;
  final String hours;
  final String minutes;

  ScheduleFormData({
    required this.departStation,
    required this.arriveStation,
    required this.travelDay,
    required this.searchTime,
    required this.hours,
    required this.minutes,
  });
}