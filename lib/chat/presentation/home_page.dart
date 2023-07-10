import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat_app/chat/presentation/bloc/chats_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:test_chat_app/chat/presentation/chat_page.dart';

class HomePage extends StatefulWidget {
  final String user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late List<Chat> chats = [];
  //final String thisUser = widget.user;
  final IO.Socket socket = IO.io(
        'https://f6c0-2806-2f0-8161-f0b5-5c3c-51ba-ac68-3c43.ngrok-free.app',
        IO.OptionBuilder()
            .setTransports(['websocket']).disableAutoConnect().build());


  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket () {
    socket.connect();

    socket.onConnect((data) {
      print("SOCKET CONNECTADO");
    });
    socket.on('server:load-chats', (data) {
      print("Cargando chats");
      context.read<ChatsBloc>().add(LoadHomePage(userId: widget.user));
    });
    socket.on('server:new-chat', (data) {
      print("Nuevo chat recibido");
      if (data == widget.user){
        print("recargando");
        context.read<ChatsBloc>().add(NewChatReceived(userId: widget.user));
      }
    });
    socket.onError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController userChatController = TextEditingController();
    return Scaffold(
        body: BlocBuilder<ChatsBloc, ChatsState>(builder: (context, state) {
      if (state is Error) {
        return Center(
          child: Text(state.error),
        );
      } else if (state is LoadingChats) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blueGrey),
        );
      } else if (state is InitialState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 170,
                        child: TextField(
                          controller: userChatController,
                          decoration: const InputDecoration(
                            hintText: "ID del usuario a mensajear"
                          ),
                        ),
                      ),
                      Container(width: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          context.read<ChatsBloc>().add(CreateChat(socketConn: socket, message: "hola", sendBy: widget.user, user1: widget.user, user2: userChatController.text));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(221, 31, 30, 30)),
                        child: const Text("Agregar chat"),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Center(child: Text("No hay chats")),),
              ],
            ),
          ),
        );
      } else if (state is LoadedChats) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 170,
                        child: TextField(
                          controller: userChatController,
                          decoration: const InputDecoration(
                            hintText: "ID usuario a mensajear"
                          ),
                        ),
                      ),
                      Container(width: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          context.read<ChatsBloc>().add(CreateChat(socketConn: socket, message: "hola", sendBy: widget.user, user1: widget.user, user2: userChatController.text));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(221, 31, 30, 30)),
                        child: const Text("Agregar chat"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Center(
                        child: state.chats!.isEmpty
                            ? Text("No hay chats")
                            : ListView.separated(
                                itemCount: state.chats!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context, MaterialPageRoute(builder: (context) =>
                                          ChatPage(chatId: state.chats![index].id, userId: widget.user,
                                          receptorId: state.chats![index].user1 != widget.user ? 
                                          state.chats![index].user1 : state.chats![index].user2,
                                          socketConn: socket)));
                                      },
                                      child: Container(
                                          height: 85,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 138, 138, 138),
                                                  spreadRadius: 0.75,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                )
                                              ],
                                              color: const Color.fromARGB(
                                                  255, 252, 252, 252)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 5),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Chat: ${state.chats![index].id}"),
                              
                                                  Text( state.chats![index].user1 != widget.user ?
                                                      "de usuario: ${state.chats![index].user1}" :
                                                      "de usuario: ${state.chats![index].user2}"
                                                  ),
                                          
                                                ]),
                                          )),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 4);
                                },
                              ))),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    }));
  }
}
