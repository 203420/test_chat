import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat_app/chat/presentation/bloc/chats_bloc.dart';
import 'package:test_chat_app/chat/presentation/login_page.dart';
import 'package:test_chat_app/usecase_config.dart';

UseCaseConfig useCaseConfig = UseCaseConfig();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatsBloc>(
          create: (BuildContext context) => ChatsBloc(
            createChatUseCase: useCaseConfig.createChatUseCase!,
            getChatUseCase: useCaseConfig.getChatUseCase!,
            getMessageUseCase: useCaseConfig.getMessageUseCase!,
            initSocketUseCase: useCaseConfig.initSocketUseCase!,
            loadChatsUseCase: useCaseConfig.loadChatsUseCase!,
            sendMessageUseCase: useCaseConfig.sendMessageUseCase!
          ),
        ),
      ], 
      child: MaterialApp(
        title: 'Test Chat app',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: const LoginPage(),
      )
    );
  }
}

