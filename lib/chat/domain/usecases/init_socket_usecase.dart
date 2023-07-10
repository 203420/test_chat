import 'package:test_chat_app/chat/domain/repositories/chat_repository.dart';

class InitSocketUseCase {
  final ChatsRepository chatsRepository;

  InitSocketUseCase(this.chatsRepository);

  Future<void> execute() async {
    await chatsRepository.initSocket();
  }
}