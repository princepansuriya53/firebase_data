import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_data/Screens/Chat/Controller/chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(title: Text('Chat: ${chatController.roomId}')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return const Center(child: Text('No messages yet'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: chatController.messages.length,
                itemBuilder: (ctx, i) {
                  final m = chatController.messages[i];
                  final isMe = m.sender == chatController.username;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.blueAccent.withValues(alpha: 0.7)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                              m.timestamp,
                            ).toLocal().toString().substring(11, 19),
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Type a message…',
                    ),
                    onSubmitted: (_) => chatController.sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: chatController.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
