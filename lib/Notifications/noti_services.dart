/* import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// initialize notifications
  Future<void> init() async {
    // request permissions (iOS)
    await _messaging.requestPermission();

    // init flutter local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);

    // handle messages while app is foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // handle messages when app opened by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened from notification: ${message.notification?.title}");
      // handle navigation if you want
    });

    // background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    print("This is data of message Body and data : ${message.data}");
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '01',
      'channel_name',
      importance: Importance.high,
      styleInformation: BigTextStyleInformation(message.notification?.body ?? ''),
      priority: Priority.high,
    );

    NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
    );
  }

  /// get FCM token
  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  /// subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// send token to backend (example)
  Future<void> sendFcmTokenToBackend(String token) async {
    // your API call here to save token
    print("Send FCM token to backend: $token");
  }
}

/// background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need, handle background messages here
  print('Handling a background message: ${message.messageId}');
}

class PushNotificationServices {
  static String pushNotificationUrl = 'https://fcm.googleapis.com/v1/projects/stk-trading-signal/messages:send';
  static final GetServerKey getServerKey = GetServerKey();

  /// Send notification to a specific FCM token
  static Future<void> sendNotificationToTopic({required String title, required String body, required Map<String, dynamic> jsonData}) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('general');
    String accessApiKey = await getServerKey.getServerKeyToken();

    var response = await http.post(
      Uri.parse(pushNotificationUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessApiKey'},
      body: jsonEncode({
        "message": {
          "topic": "general",
          "notification": {"title": title, "body": body},
          "data": jsonData,
        },
      }),
    );

    if (response.statusCode == 200) {
      debugPrint("✅ Notification sent successfully");
      Map<String, dynamic> data = {'title': title, 'description': body, 'createdAt': DateTime.now()};
      data.addAll(jsonData);
      await NotificationDBService().storeNotification(data);
    } else {
      debugPrint("❌ Failed to send notification: ${response.statusCode}");
      debugPrint("🔍 Response: ${response.body}");
    }
  }

  static Future<void> sendNotificationToToken(token, title, body) async {
    String accessApiKey = await getServerKey.getServerKeyToken();

    var response = await http.post(
      Uri.parse(pushNotificationUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessApiKey'},
      body: jsonEncode({
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "message": "Sample Notification Message"},
        },
      }),
    );

    if (response.statusCode == 200) {
      debugPrint("✅ Notification sent successfully");
    } else {
      debugPrint("❌ Failed to send notification: ${response.statusCode}");
      debugPrint("🔍 Response: ${response.body}");
    }
  }
}

class NotificationDBService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// store a notification (single)
  Future<void> storeNotification(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not logged in");
    }

    // store in user sub-collection
    // await _firestore.collection(AppConfig.notification).add(data);
  }

  /// get list of notifications
 /*  Future<List<Map<String, dynamic>>> getNotifications() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    // final snapshot = await _firestore.collection(AppConfig.notification).orderBy('createdAt', descending: true).get();

    final listNotification = snapshot.docs.map((doc) => doc.data()).toList();
    return listNotification;
  } */
}
 */