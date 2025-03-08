import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/schedule.model.dart';

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
    ).subtract(const Duration(minutes: 15)); // Subtract 1 minute

    // Convert to TZDateTime in the local timezone
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationTime, tz.local);

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
