import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatsRepository chatsRepository;

  SendMessageUseCase(this.chatsRepository);

  Future<bool> execute(userId, chatId, message) async {
    return await chatsRepository.updateChat(userId, chatId, message);
  }
}