import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key? key}) : super(key: key);
  final String message;
  final String username;
  final bool isMe;
  final String imageUrl;
  MessageBubble(
    this.message,
    this.username,
    this.isMe,
      this.imageUrl
  );

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 9),
                width: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                  color: isMe ? Colors.greenAccent : Colors.orangeAccent,
                ),
                child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                    ]),
              ),
              Positioned(
                child: CircleAvatar( backgroundImage : NetworkImage( imageUrl ),),
                top: -10,
                left: isMe ? null : 135,
                right: isMe ? 130 : null,
              ),
            ],
            clipBehavior: Clip.none,
          )
        ]);
  }
}
