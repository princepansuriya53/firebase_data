import 'package:firebase_data/Screens/Chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userCtrl = TextEditingController();
    final TextEditingController peerCtrl = TextEditingController();

    void goChat() {
      final u = userCtrl.text.trim();
      final p = peerCtrl.text.trim();
      if (u.isEmpty || p.isEmpty) return;
      // generate consistent roomId
      final names = [u, p]..sort();
      final roomId = '${names[0]}_${names[1]}';
      Get.to(() => ChatPage(), arguments: {'username': u, 'roomId': roomId});
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login / Start Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: peerCtrl,
              decoration: const InputDecoration(labelText: 'Peer Name'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: goChat, child: const Text('Go to Chat')),
          ],
        ),
      ),
    );
  }
}
