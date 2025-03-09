class Schedule {

  Schedule({
    required this.trainNo,
    required this.departTime,
    required this.departStation,
    required this.arriveTime,
    required this.arriveStation,
    required this.travelDay,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      trainNo: json['trainNo'] as String,
      departTime: json['departTime'] as String,
      departStation: json['departStation'] as String,
      arriveTime: json['arriveTime'] as String,
      arriveStation: json['arriveStation'] as String,
      travelDay: json['travelDay'] as String,
    );
  }
  final String trainNo;
  final String departTime;
  final String departStation;
  final String arriveTime;
  final String arriveStation;
  final String travelDay;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'trainNo': trainNo,
      'departTime': departTime,
      'departStation': departStation,
      'arriveTime': arriveTime,
      'arriveStation': arriveStation,
      'travelDay': travelDay,
    };
  }
}
