import 'package:flutter/material.dart';
import 'social_model.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final SocialManager _socialManager = SocialManager();
  final TextEditingController _msgController = TextEditingController();
  bool isPublicChat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المجتمع والأصدقاء والشات'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط التنقل بين أقسام المجتمع
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => isPublicChat = true),
                  icon: const Icon(Icons.public),
                  label: const Text('الشات العام'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPublicChat ? Colors.blue : Colors.grey[300],
                    foregroundColor: isPublicChat ? Colors.white : Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => isPublicChat = false),
                  icon: const Icon(Icons.chat),
                  label: const Text('الأصدقاء والخاص'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isPublicChat ? Colors.blue : Colors.grey[300],
                    foregroundColor: !isPublicChat ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى الشاشة بناءً على التبويب المختار
          Expanded(
            child: isPublicChat ? _buildPublicChatSection() : _buildFriendsAndSocialSection(),
          ),
        ],
      ),
    );
  }

  // قسم الشات العام
  Widget _buildPublicChatSection() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _socialManager.publicMessages.length,
            itemBuilder: (context, index) {
              final msg = _socialManager.publicMessages[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(msg.senderName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(msg.message),
                  trailing: Text('${msg.timestamp.hour}:${msg.timestamp.minute}', style: const TextStyle(fontSize: 12)),
                ),
              );
            },
          ),
        ),
        _buildMessageInputField(isPublic: true),
      ],
    );
  }

  // قسم الأصدقاء وطلبات الصداقة والحظر
  Widget _buildFriendsAndSocialSection() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        const Text('طلبات الصداقة الواردة:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ..._socialManager.pendingRequests.map((user) => ListTile(
          title: Text(user.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => setState(() => _socialManager.acceptFriendRequest(user)),
                tooltip: 'قبول',
              ),
              IconButton(
                icon: const Icon(Icons.block, color: Colors.red),
                onPressed: () => setState(() => _socialManager.blockUser(user)),
                tooltip: 'حظر',
              ),
            ],
          ),
        )),
        const Divider(),
        const Text('قائمة الأصدقاء:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ..._socialManager.friends.map((user) => ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person, color: Colors.white)),
          title: Text(user.name),
          trailing: IconButton(
            icon: const Icon(Icons.block, color: Colors.red),
            onPressed: () => setState(() => _socialManager.blockUser(user)),
            tooltip: 'حظر المستخدم',
          ),
        )),
      ],
    );
  }

  // مربع كتابة وإرسال الرسائل
  Widget _buildMessageInputField({required bool isPublic}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_msgController.text.trim().isNotEmpty) {
                setState(() {
                  if (isPublic) {
                    _socialManager.sendPublicMessage('أنا (المستخدم)', _msgController.text.trim());
                  } else {
                    _socialManager.sendPrivateMessage('أنا (المستخدم)', _msgController.text.trim());
                  }
                  _msgController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
