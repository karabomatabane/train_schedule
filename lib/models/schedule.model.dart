class Schedule {
  final String trainNo;
  final String departTime;
  final String departStation;
  final String arriveTime;
  final String arriveStation;

  Schedule({
    required this.trainNo,
    required this.departTime,
    required this.departStation,
    required this.arriveTime,
    required this.arriveStation,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    print(json);
    return Schedule(
      trainNo: json['trainNo'] as String,
      departTime: json['departTime'] as String,
      departStation: json['departStation'] as String,
      arriveTime: json['arriveTime'] as String,
      arriveStation: json['arriveStation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainNo': trainNo,
      'departTime': departTime,
      'departStation': departStation,
      'arriveTime': arriveTime,
      'arriveStation': arriveStation,
    };
  }
}
