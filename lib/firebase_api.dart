import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background message received:');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  // Show the local notification
  await showLocalNotification(message);
}

Future<void> showLocalNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Replace with your channel ID
          'your_channel_name', // Replace with your channel name
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher', // Replace with your icon
        ),
      ),
    );
  }
}


class FirebaseApi {
  FirebaseApi._privateConstructor();
  static final FirebaseApi _instance = FirebaseApi._privateConstructor();
  factory FirebaseApi() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String token = '';

  Future<void> initNotifications() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission for iOS
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    token = fcmToken!;
    print('FcmToken: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      showLocalNotification(message); // Show local notification
    });
  }

  String get getToken => token;
}

