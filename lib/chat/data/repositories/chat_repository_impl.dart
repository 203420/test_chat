import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/entities/message.dart';
import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';
import 'package:test_chat_app/chat/data/datasources/chat_remote_datasource.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsRemoteDataSource chatsRemoteDataSource;

  ChatsRepositoryImpl({required this.chatsRemoteDataSource});

  @override
  Future<List<Chat>?> getChatList(String userId) async {
    return await chatsRemoteDataSource.getChatList(userId);
  }

  @override
  Future<Chat?> getChat(String id) async {
    return await chatsRemoteDataSource.getChat(id);
  }

  @override
  Future<Message?> getMessage(String userId, String chatId) async {
    return await chatsRemoteDataSource.getMessage(userId, chatId);
  }

  @override
  Future<bool> updateChat(String userId, String chatId, String message) async {
    return await chatsRemoteDataSource.updateChat(userId, chatId, message);
  }

  @override
  Future<bool> createChat(String message, String sendBy, String user1, String user2) async {
    return await chatsRemoteDataSource.createChat(message, sendBy, user1, user2);
  }

  @override
  Future<void> initSocket() async {
    await chatsRemoteDataSource.initSocket();
  }
}