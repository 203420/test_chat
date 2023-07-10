import 'package:test_chat_app/chat/data/datasources/chat_remote_datasource.dart';
import 'package:test_chat_app/chat/data/repositories/chat_repository_impl.dart';
import 'package:test_chat_app/chat/domain/usecases/create_chat_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/get_chat_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/get_message_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/init_socket_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/load_chats_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/send_message_usecase.dart';

class UseCaseConfig {
  CreateChatUseCase? createChatUseCase;
  GetChatUseCase? getChatUseCase;
  GetMessageUseCase? getMessageUseCase;
  InitSocketUseCase? initSocketUseCase;
  LoadChatsUseCase? loadChatsUseCase; 
  SendMessageUseCase? sendMessageUseCase;

  ChatsRepositoryImpl? chatsRepositoryImpl;
  ChatsRemoteDataSourceImp? chatsRemoteDataSourceImp;

  UseCaseConfig() {
    chatsRemoteDataSourceImp = ChatsRemoteDataSourceImp();
    chatsRepositoryImpl = ChatsRepositoryImpl(chatsRemoteDataSource: chatsRemoteDataSourceImp!);

    createChatUseCase = CreateChatUseCase(chatsRepositoryImpl!);
    getChatUseCase = GetChatUseCase(chatsRepositoryImpl!);
    getMessageUseCase = GetMessageUseCase(chatsRepositoryImpl!);
    initSocketUseCase = InitSocketUseCase(chatsRepositoryImpl!);
    loadChatsUseCase = LoadChatsUseCase(chatsRepositoryImpl!); 
    sendMessageUseCase = SendMessageUseCase(chatsRepositoryImpl!);
  }
}