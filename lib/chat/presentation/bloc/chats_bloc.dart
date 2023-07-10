import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/entities/message.dart';
import 'package:test_chat_app/chat/domain/usecases/create_chat_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/get_chat_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/get_message_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/init_socket_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/load_chats_usecase.dart';
import 'package:test_chat_app/chat/domain/usecases/send_message_usecase.dart';

part 'chats_state.dart';
part 'chats_events.dart';

class ChatsBloc extends Bloc<ChatsEvents, ChatsState> {
  final CreateChatUseCase createChatUseCase;
  final GetChatUseCase getChatUseCase;
  final GetMessageUseCase getMessageUseCase;
  final InitSocketUseCase initSocketUseCase;
  final LoadChatsUseCase loadChatsUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatsBloc({
    required this.createChatUseCase,
    required this.getChatUseCase,
    required this.getMessageUseCase,
    required this.initSocketUseCase,
    required this.loadChatsUseCase,
    required this.sendMessageUseCase,
  }) : super(InitialState()) {
    on<ChatsEvents>((event, emit) async {
      if (event is LoadHomePage){
       try {
          emit(LoadingChats());
          final List<Chat>? chats = await loadChatsUseCase.execute(event.userId);
          if (chats != null){
            emit(LoadedChats(chats: chats));
          } else {
            emit(Error(error: 'Ocurrio un error cargando los chats'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
       } catch (e) {
         emit(Error(error: e.toString()));
       }
      }

      else if (event is LoadChatPage){
        try {
          
          emit(LoadingChat());
          final Chat? chat = await getChatUseCase.execute(event.chatId);
           if (chat != null){
            emit(LoadedChat(chat: chat));
          } else {
            emit(Error(error: 'Ocurrio un error cargando los mensjaes'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }

      else if (event is NewChatReceived){
        try {
          emit(LoadingChats());
          final List<Chat>? chats = await loadChatsUseCase.execute(event.userId);
          if (chats != null){
            emit(LoadedChats(chats: chats));
          } else {
            emit(Error(error: 'Ocurrio un error cargando los chats'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
       } catch (e) {
         emit(Error(error: e.toString()));
       }
      }

      else if (event is NewMessageRceived){
        try {
          emit(LoadingMesage());
          final Message? msg = await getMessageUseCase.execute(event.userId, event.chatId);
          if (msg != null){
            emit(LoadedMessage(message: msg));
          } else {
            emit(Error(error: 'Ocurrio un error cargando los mensajaes'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }

      else if (event is CreateChat){
        try {
          emit(LoadingChats());
          final bool created = await createChatUseCase.execute(event.message, event.sendBy, event.user1, event.user2);
          print(created);
          if (created == true){
            print("AQUI");
            final List<Chat>? chats = await loadChatsUseCase.execute(event.sendBy);
            if (chats != null) {
              //event.socketConn.connect();
              
              final String sendTo = event.sendBy == event.user1 ? event.user2 : event.user1;
              event.socketConn.emit('client:new-chat', sendTo);
              emit(LoadedChats(chats: chats));
            }
          } else{
            emit(Error(error: 'Ocurrio un error cargando los chats'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }

      else if (event is SendMessage){
        try {
          emit(LoadingMesage());
          final bool sent = await sendMessageUseCase.execute(event.userId, event.chatId, event.message);
          if (sent == true){
            final Chat? chat = await getChatUseCase.execute(event.chatId);
            if (chat != null){
              event.socketConn.emit('client:new-message', event.sendTo);
              emit(LoadedChat(chat: chat));
            }
            // final Message? msg = await getMessageUseCase.execute(event.userId, event.chatId);
            // if (msg != null) {
            //   event.socketConn.emit('client:new-message', event.sendTo);
            //   emit(LoadedMessage(message: msg));
            // }
          }  else{
            emit(Error(error: 'Ocurrio un error cargando los mensajes'));
            await Future.delayed(const Duration(milliseconds: 2500), () {
              emit(InitialState());
            });
          }
        } catch (e) {
          emit(Error(error: e.toString()));
        }
      }
    });
  }
}