import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:test_chat_app/chat/domain/entities/chat.dart';
import 'package:test_chat_app/chat/domain/entities/message.dart';

abstract class ChatsRemoteDataSource {
  Future<List<Chat>?> getChatList(String userId);
  Future<Chat?> getChat(String id);
  Future<Message?> getMessage(String userId, String chatId);
  Future<bool> updateChat(String userId, String chatId, String message);
  Future<bool> createChat(String message, String sendBy, String user1, String user2);
  Future<void> initSocket();
}

class ChatsRemoteDataSourceImp implements ChatsRemoteDataSource {
  final dio = Dio();
  final String apiURL = 'https://f6c0-2806-2f0-8161-f0b5-5c3c-51ba-ac68-3c43.ngrok-free.app';
  late IO.Socket socket;


  @override
  Future<List<Chat>?> getChatList(String userId) async {
    late List<Chat> chats = [];
    try {
      Response res = await dio.get('$apiURL/chats/list/$userId');
      if (res.statusCode == 200) {
        var chatsList = res.data;
        if (chatsList.length > 0) {
          for (var object in chatsList) {
            var messagesJson = object['messages'];
            List<Message> messages = [];

            for (var messageJson in messagesJson) {
              var message = Message(
                message: messageJson['message'],
                sendBy: messageJson['sendBy'].toString(),
                timeStamp: messageJson['timeStamp'],
              );
              messages.add(message);
            }
            var chat = Chat(
              id: object['id'].toString(),
              messages: messages,
              user1: object['user1'].toString(),
              user2: object['user2'].toString(),
            );
            chats.add(chat);
          }
        }
        return chats;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<Chat?> getChat(String id) async {
    try {
      Response res = await dio.get('$apiURL/chats/$id');
      if (res.statusCode == 200) {
        //print(res.data);
        var messagesJson = res.data['messages'];
        List<Message> messages = [];
        for (var messageJson in messagesJson) {
          var message = Message(
          message: messageJson['message'],
          sendBy: messageJson['sendBy'].toString(),
          timeStamp: messageJson['timeStamp'],
          );
          messages.add(message);
        }
        return Chat(id: res.data['id'].toString(), messages: messages, user1: res.data['user1'].toString(), user2: res.data['user2'].toString());
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<Message?> getMessage(String userId, String chatId) async {
     try {
      Response res = await dio.get('$apiURL/chats/msg/', data: {'userID': userId, 'chatId': chatId});
      if (res.statusCode == 200) {
        print(res.data);
        return Message(message: res.data['message'], sendBy: res.data['sendBy'], timeStamp: res.data['timeStamp']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<bool> updateChat(String userId, String chatId, String message) async {
    FormData formData = FormData.fromMap({
      "message": message,
      "sendBy": userId,
    });
    try {
      Response res = await dio.put('$apiURL/chats/msg/$chatId', data: formData);
      if (res.statusCode == 200) {
        print(res.data);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<bool> createChat(String message, String sendBy, String user1, String user2) async {
    FormData formData = FormData.fromMap(
        {"message": message, "sendBy": sendBy, "user1": user1, "user2": user2});
    try {
      Response res = await dio.post('$apiURL/chats/', data: formData);
      if (res.statusCode == 200) {
        print(res.data);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<void> initSocket() async {
    socket = IO.io(
        apiURL,
        IO.OptionBuilder().setTransports(['websocket']).setQuery({'userId': 1}).build());

    socket.onConnect((data) {
      print("CONNECTED");
    });
    socket.on('server:load-chats', (data) {
      print("Cargando chats");
    });
    socket.on('server:new-chat', (data) {
      print("nuevo chat");
    });
    socket.on('server:new-message', (data) {
      print("nuevo mensaje");
    });
    socket.onError((err) {
      print(err);
    });
  }
}