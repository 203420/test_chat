import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class CreateChatUseCase {
  final ChatsRepository chatsRepository;

  CreateChatUseCase(this.chatsRepository);

  Future<bool> execute(message, sendBy, user1, user2) async {
    return await chatsRepository.createChat(message, sendBy, user1, user2);
  }
}