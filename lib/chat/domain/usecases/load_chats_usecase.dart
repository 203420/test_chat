import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class LoadChatsUseCase {
  final ChatsRepository chatsRepository;

  LoadChatsUseCase(this.chatsRepository);

  Future<List<Chat>?> execute(userId) async {
    return await chatsRepository.getChatList(userId);
  }
}