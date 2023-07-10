import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class GetChatUseCase {
  final ChatsRepository chatsRepository;

  GetChatUseCase(this.chatsRepository);

  Future<Chat?> execute(id) async {
    return await chatsRepository.getChat(id);
  }
}