import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/Widgets/messages.dart';
import 'package:flutter_chat/Widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutter Chat',
            style: TextStyle(color: Colors.yellowAccent),
          ),
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Text('Logout'),
                          SizedBox(width: 8),
                          Icon(Icons.logout)
                        ],
                      ),
                    ),
                    value: 'logout',
                  )
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: [Expanded(child: Messages()), NewMessage()],
          ),
        ));
  }
}
