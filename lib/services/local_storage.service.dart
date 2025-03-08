import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/schedule.model.dart';
import '../utils/util.dart';

class LocalStorageService {

  LocalStorageService(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  Future<void> saveString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  // Save list of schedules
  Future<void> saveScheduleList(List<Schedule> schedules) async {
    final List<Map<String, dynamic>> scheduleJson = schedules.map((Schedule schedule) => schedule.toJson()).toList();
    await _sharedPreferences.setString('schedules', jsonEncode(scheduleJson));
  }

  // Save a single schedule
  Future<bool> saveSchedule(Schedule schedule) async {
    final List<Schedule> schedules = await getScheduleList();
    // check if schedule already exists
    if(Util.containsSchedule(schedules, schedule)) {
      return false;
    }
    schedules.add(schedule);
    await saveScheduleList(schedules);
    return true;
  }

  Future<void> deleteSchedule(Schedule schedule) async {
    final List<Schedule> schedules = await getScheduleList();
    schedules.removeWhere((Schedule s) => Util.isSchedulesEqual(s, schedule));
    await saveScheduleList(schedules);
  }

  // Retrieve list of schedules
  Future<List<Schedule>> getScheduleList() {
    final String? scheduleString = _sharedPreferences.getString('schedules');
    if (scheduleString == null) {
      return Future<List<Schedule>>.value(<Schedule>[]);
    }
    final List<dynamic> scheduleJson = jsonDecode(scheduleString) as List<dynamic>;
    print(scheduleJson);
    try {
      return Future<List<Schedule>>.value(scheduleJson.map((dynamic json) => Schedule.fromJson(json as Map<String, dynamic>)).toList());
    } catch (e) {
      print('Error: $e');
      return Future<List<Schedule>>.value(<Schedule>[]);
    }
  }

  Future<void> clearAll() async {
    await _sharedPreferences.clear();
  }
}