import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:work_app/screens/splash_screen/splash_screen.dart';

void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Work App Notification',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
      )
    ],
    debug: true,
  );

  _scheduleNotificationForNextSpecificTime();

  runApp(const MyApp());
}

void _scheduleNotificationForNextSpecificTime() {
  DateTime now = DateTime.now();
  DateTime targetTime = DateTime(now.year, now.month, now.day, 09, 00);

  print("Şu anki zaman: $now");
  print("Hedef zaman: $targetTime");

  if (now.isAfter(targetTime)) {
    targetTime = targetTime.add(Duration(days: 1));
  }

  print("Yeni hedef zaman: $targetTime");

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'İş Zamanı',
      body: 'Günlük iş vaxti geldi!',
    ),
    schedule: NotificationCalendar(
      year: targetTime.year,
      month: targetTime.month,
      day: targetTime.day,
      hour: targetTime.hour,
      minute: targetTime.minute,
      second: 0,
      millisecond: 0,
      preciseAlarm: true,
      repeats: true,
    ),
  ).then((value) => print("Bildirim duzeldildi: $value")).catchError((error) => print("Bildirim oluşturulurken hata: $error"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Team Work Time",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      Position position = await _getCurrentLocation();
      print('Enlem: ${position.latitude}, Boylam: ${position.longitude}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } catch (e) {
      print('Konum alınamadı: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
