import 'package:test_chat_app/chat/domain/entities/message.dart';

class Chat {
  final String id;
  final List<Message> messages;
  final String user1;
  final String user2;

  Chat({
    required this.id,
    required this.messages,
    required this.user1,
    required this.user2
  });
}
