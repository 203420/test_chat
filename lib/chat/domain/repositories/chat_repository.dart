import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/entities/message.dart';

abstract class ChatsRepository {
  Future<List<Chat>?> getChatList(String userId);
  Future<Chat?> getChat(String id);
  Future<Message?> getMessage(String userId, String chatId);
  Future<bool> updateChat(String userId, String chatId, String message);
  Future<bool> createChat(String message, String sendBy, String user1, String user2);
  Future<void> initSocket();
}