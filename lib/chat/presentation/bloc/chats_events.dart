part of 'chats_bloc.dart';

abstract class ChatsEvents {}

class LoadHomePage extends ChatsEvents {
  final String userId;
  LoadHomePage({required this.userId});
}

class NewChatReceived extends ChatsEvents {
  final String userId;
  NewChatReceived({required this.userId});
}

class LoadChatPage extends ChatsEvents {
  final String chatId;
  LoadChatPage({required this.chatId});
}

class NewMessageRceived extends ChatsEvents {
  final String userId;
  final String chatId;
  NewMessageRceived({required this.userId, required this.chatId});
}

class CreateChat extends ChatsEvents {
  final IO.Socket socketConn;
  final String message;
  final String sendBy;
  final String user1;
  final String user2;
  CreateChat({required this.socketConn, required this.message, required this.sendBy, required this.user1, required this.user2});
}

class SendMessage extends ChatsEvents {
  final IO.Socket socketConn;
  final String userId;
  final String chatId;
  final String message;
  final String sendTo;
  SendMessage({required this.socketConn, required this.userId, required this.chatId, required this.message, required this.sendTo});
}