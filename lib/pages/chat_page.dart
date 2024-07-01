import 'package:flutter/material.dart';
import 'package:flutter_projects/components/user_tile.dart';
import 'package:flutter_projects/pages/chat_specific_person_page.dart';
import 'package:flutter_projects/services/auth/auth_service.dart';
import 'package:flutter_projects/services/chat/chat_service.dart';

class Chat extends StatelessWidget {
  //home page
  Chat({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Chat Page"),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentuser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatSpecificPersonPage(
                          receiverEmail: userData["email"],
                          receiverID: userData["uid"],
                        )));
          });
    } else {
      return Container();
    }
  }
}
