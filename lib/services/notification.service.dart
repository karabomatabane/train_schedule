import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../models/schedule.model.dart';
import '../utils/constants.dart';

class NotificationService {
  Future<void> scheduleNotification(Schedule schedule) async {
    // Initialize timezone database
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Parse the departure time
    final DateTime departureTime = DateFormat('HH:mm').parse(schedule.departTime);
    // Get the current date and time in the local timezone
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Create a DateTime object with the correct date and parsed time
    final DateTime notificationTime = DateTime(
      now.year,
      now.month,
      now.day,
      departureTime.hour,
      departureTime.minute,
    ).subtract(const Duration(minutes: 10)); // Subtract 1 minute

    // Convert to TZDateTime in the local timezone
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

    // Check if today is one of the chosen days
    final int today = DateTime.now().weekday;
    // find the index of the day in the list
    final int day = Constants.travelDays.keys.toList().indexOf(schedule.travelDay);

    // Check if the notification should be scheduled based on the travel day preference
    final bool shouldSchedule = switch (day) {
      0 => today >= 1 && today <= 5, // Mon-Fri (weekdays)
      1 => today == 6,               // Sat
      2 => today == 7,               // Sun
      _ => false                     // Invalid day selection
    };

    if (!shouldSchedule) {
      // Find the next matching travel day if today doesn't match the preference
      int daysUntilNext = 0;
      switch (day) {
        case 0: // Weekdays
          if (today >= 1 && today <= 5) break; // Already a weekday
          daysUntilNext = (today == 6) ? 2 : 1; // Sat -> Mon, Sun -> Mon
          break;
        case 1: // Saturday
          daysUntilNext = (6 - today) % 7;
          break;
        case 2: // Sunday
          daysUntilNext = (7 - today) % 7;
          break;
        default:
          return; // Invalid day selection
      }

      scheduledDate = scheduledDate.add(Duration(days: daysUntilNext));
    } else if (scheduledDate.isBefore(now)) {
      // Schedule for the same travel day next week if the time has passed
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }


    // If the scheduled time has already passed today, schedule it for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    AndroidScheduleMode androidScheduleMode;

    //check alarm permission
    if (await Permission.scheduleExactAlarm.isGranted) {
      androidScheduleMode = AndroidScheduleMode.alarmClock;
    } else {
      androidScheduleMode = AndroidScheduleMode.exact;
    }

    //send test notification
    // await flutterLocalNotificationsPlugin.show(
    //   0, // Notification ID (unique for each notification)
    //   'Train Departure Reminder', // Notification title
    //   'Your train ${schedule.trainNo} from ${schedule.departStation} to ${schedule.arriveStation} departs in 15 minutes.',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'train_schedule_channel', // Channel ID
    //       'Train Schedule Notifications', // Channel name
    //       channelDescription: 'Notifications for train schedules',
    //       // Channel description
    //       importance: Importance.high,
    //       priority: Priority.high,
    //     ),
    //   ),
    // );

    // final tz.TZDateTime testTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID (unique for each notification)
      'Train Departure Reminder', // Notification title
      'Your train ${schedule.trainNo} from ${schedule.departStation} to ${schedule.arriveStation} departs in 15 minutes.',
      // Notification body
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'train_schedule_channel', // Channel ID
          'Train Schedule Notifications', // Channel name
          channelDescription: 'Notifications for train schedules',
          // Channel description
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: androidScheduleMode,
    );
  }
}
