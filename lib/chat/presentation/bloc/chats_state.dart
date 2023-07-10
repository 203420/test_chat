part of 'chats_bloc.dart';

abstract class ChatsState {}

class InitialState extends ChatsState {}

class LoadingChats extends ChatsState {}

class LoadingChat extends ChatsState {}

class LoadingMesage extends ChatsState {}

class LoadedChats extends ChatsState {
  final List<Chat>? chats;
  LoadedChats({required this.chats});
}

class LoadedChat extends ChatsState {
  final Chat? chat;
  LoadedChat({required this.chat});
}

class LoadedMessage extends ChatsState {
  final Message? message;
  LoadedMessage({required this.message});
}

class Error extends ChatsState {
  final String error;
  Error({required this.error});
}
