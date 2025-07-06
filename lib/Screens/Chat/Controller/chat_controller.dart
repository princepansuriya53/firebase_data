import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final int timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> m) {
    return ChatMessage(
      id: id,
      text: m['text'] as String? ?? '',
      sender: m['sender'] as String? ?? '',
      timestamp: m['timestamp'] as int? ?? 0,
    );
  }
}

class ChatController extends GetxController {
  late final String roomId;
  late final String username;
  late final DatabaseReference dbRef;

  final TextEditingController messageCtrl = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, String>;
    username = args['username']!;
    roomId = args['roomId']!;
    dbRef = FirebaseDatabase.instance.ref('chats/$roomId/messages');

    dbRef.orderByChild('timestamp').onValue.listen((event) {
      final raw = event.snapshot.value as Map<dynamic, dynamic>?;
      if (raw != null) {
        final list =
            raw.entries
                .map((e) => ChatMessage.fromMap(e.key as String, e.value))
                .toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        messages.value = list;
      } else {
        messages.clear();
      }
    });
  }

  void sendMessage() {
    final text = messageCtrl.text.trim();
    if (text.isEmpty) return;

    dbRef.push().set({
      'text': text,
      'sender': username,
      'timestamp': ServerValue.timestamp,
    });
    messageCtrl.clear();
  }

  @override
  void onClose() {
    messageCtrl.dispose();
    super.onClose();
  }
}
