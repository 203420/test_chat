import 'package:flutter/material.dart';
import 'package:test_chat_app/chat/presentation/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: userController,
                  decoration: const InputDecoration(
                    hintText: "User Id"
                  ),
                ),
                ElevatedButton(
                  onPressed: () { 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: userController.text)));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(221, 31, 30, 30)),
                  child: const Text("Ingresar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}