import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat_app/chat/domain/entities/message.dart';
import 'package:test_chat_app/chat/presentation/bloc/chats_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userId;
  final String receptorId;
  final IO.Socket socketConn;
  const ChatPage({Key? key, required this.chatId, required this.userId, required this.receptorId, required this.socketConn}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  void initState() {
    super.initState();
    connectSocket();
    context.read<ChatsBloc>().add(LoadChatPage(chatId: widget.chatId));
  }

  void connectSocket() {
    widget.socketConn.on('server:new-message', (data) {
      print("Nuevo mensaje recibido");
      if (data == widget.userId){
        context.read<ChatsBloc>().add(LoadChatPage(chatId: widget.chatId));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //late List<Message> messages = [];
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();


    return Scaffold(
      appBar: AppBar(
        title: Text("ID del chat: ${widget.chatId} - USUARIO: ${widget.receptorId}"),
      ),
      body: BlocBuilder<ChatsBloc, ChatsState>(builder: (context, state) {
        if (state is Error) {
        return Center(
          child: Text(state.error),
        );
      } else if (state is LoadingChat || state is LoadingMesage){
        return const Center(
          child: CircularProgressIndicator(color: Colors.blueGrey),
        );
      } else if (state is LoadedChat) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: state.chat != null && state.chat!.messages.isNotEmpty ?
                  ListView.separated(
                    reverse: false,
                    scrollDirection: Axis.vertical,
                    
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        child: Align(
                          alignment: state.chat!.messages[index].sendBy == widget.userId ?
                          Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: state.chat!.messages[index].sendBy == widget.userId ?
                            Colors.blue : Color.fromARGB(255, 167, 167, 167),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Text(state.chat!.messages[index].message),
                                  ),
                                  Align(alignment: Alignment.centerRight ,child: Text(state.chat!.messages[index].timeStamp))
                                ],
                              ),
                            )
                          ),
                        ),
                      );
                    },
                    controller: scrollController,
                     
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 7);
                    }, 

                    itemCount: state.chat!.messages.length,
                    
                  ): const Text("No hay mensajes")
                ),
              ),
              Container(
                width: double.infinity,
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Mensaje...",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.read<ChatsBloc>().add(SendMessage(socketConn: widget.socketConn, userId: widget.userId, chatId: widget.chatId, message: messageController.text, sendTo: widget.receptorId));
                      }, 
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10)
                      ),
                      child: const Icon(Icons.send)
                    ),
        
                  ],
                ),
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
      }),
    );
  }
}