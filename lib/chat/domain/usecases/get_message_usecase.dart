import 'package:test_chat_app/chat/domain/entities/message.dart';
import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class GetMessageUseCase {
  final ChatsRepository chatsRepository;

  GetMessageUseCase(this.chatsRepository);

  Future<Message?> execute(userId, chatId) async {
    return await chatsRepository.getMessage(userId, chatId);
  }
}