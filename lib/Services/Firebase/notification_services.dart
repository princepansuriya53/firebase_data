import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  // Singleton
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize Firebase, request permissions, and configure handlers.
  Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request permission (iOS/macOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications for foreground
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );
    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );

    // Handlers
    FirebaseMessaging.onMessage.listen(onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Get the device's FCM token
  Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();
    print('FCM Device Token: $token');
    return token;
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Send a push notification via FCM HTTP API
  Future<void> sendPushMessage({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final serverKey = '<YOUR_SERVER_KEY>';

    final payload = {
      'to': token,
      'notification': {'title': title, 'body': body},
      'data': data ?? {},
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Push message sent');
    } else {
      print('Failed to send push: ${response.statusCode}');
    }
  }

  /// Local notification tap handler
  Future<void> onSelectNotification(String? payload) async {
    // handle notification tapped logic here
    print('Notification tapped with payload: $payload');
  }

  /// Foreground message handler
  Future<void> onMessageHandler(RemoteMessage message) async {
    print('Received foreground message: ${message.notification?.title}');
    showLocalNotification(message);
  }

  /// Message opened app from background
  Future<void> onMessageOpenedApp(RemoteMessage message) async {
    print('Opened from background: ${message.notification?.title}');
    // navigate or handle data
  }

  /// Display a local notification when app is in foreground
  Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          priority: Priority.high,
          importance: Importance.max,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Background message handler must be a top-level function
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print('Background message: ${message.notification?.title}');
  }
}
