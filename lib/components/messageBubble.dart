import 'package:flutter/material.dart';

// Sender parameter is redundant
class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isme});

  final String sender;
  final String text;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   sender,
          //   style: TextStyle(fontSize: 12.0, color: Colors.black54),
          // ),
          Container(
            constraints: BoxConstraints(maxWidth: data.size.width/1.4,),
            child: Material(
              borderRadius: isme
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              elevation: 5.0,
              color: isme ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isme ? Colors.white : Colors.black,
                  ),
                ),
              ),
              
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
