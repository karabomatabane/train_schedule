import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nested/nested.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/saved_schedules/saved_schedules_bloc.dart';
import 'bloc/schedule_form/schedule_form_bloc.dart';
import 'bloc/schedules/schedules_bloc.dart';
import 'pages/home.page.dart';
import 'services/cttrain.service.dart';
import 'services/local_storage.service.dart';
import 'theme/colours.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the notification plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'ic_notification'); // Use your app's launcher icon
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  initPermissionsAndNotifications();
  final TrainService trainService = TrainService();
  final SharedPreferences prefs =
      await SharedPreferences.getInstance(); // Initialize your TrainService
  runApp(MyApp(
    trainService: trainService,
    prefs: prefs,
  ));
}

Future<void> initPermissionsAndNotifications() async {
  await checkAndRequestExactAlarmPermission();
  await checkAndRequestNotificationPermissions();
  await createNotificationChannel();
}

Future<void> checkAndRequestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    // Request the permission
    final PermissionStatus status =
        await Permission.scheduleExactAlarm.request();
    if (status.isDenied) {
      // Permission is denied, handle accordingly
      print('Exact alarm permission denied');
    }
  }
}

Future<void> checkAndRequestNotificationPermissions() async {
  if (await Permission.notification.isDenied) {
    // Request the permission
    final PermissionStatus status = await Permission.notification.request();
    if (status.isDenied) {
      // Permission is denied, handle accordingly
      print('Notification permission denied');
    }
  }
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'train_schedule_channel', // Channel ID
    'Train Schedule Notifications', // Channel name
    description: 'Notifications for train schedules', // Channel description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.trainService, required this.prefs});

  final TrainService trainService;
  final SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<SchedulesBloc>(
          create: (BuildContext context) =>
              SchedulesBloc(trainService: trainService),
        ),
        BlocProvider<SavedSchedulesBloc>(
          create: (BuildContext context) => SavedSchedulesBloc(
            localStorageService: LocalStorageService(prefs),
          ),
        ),
        BlocProvider<ScheduleFormBloc>(
          create: (BuildContext context) => ScheduleFormBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Cape Town Train Schedule',
        theme: ThemeData(
            //set dark theme
            colorScheme: darkColorScheme,
            useMaterial3: true,
            bottomSheetTheme: const BottomSheetThemeData(
                surfaceTintColor: Colors.transparent)),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
