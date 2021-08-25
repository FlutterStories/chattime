import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class ChattingScreen extends StatefulWidget {
  static final String id = 'chatting_screen';

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final _textFieldEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText; // Hello World!!

  Future getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      } else {
        print("User is null");
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessagesFromFirestore() async {
  //   final messagesInCloud = await _fireStore.collection('messages').get();
  //   for (var mess in messagesInCloud.docs) {
  //     print(mess.data());
  //   }
  // }

  // void getMessagesFromFirestoreUsingStreams() async {
  //   await for (var snapshot in _fireStore.collection('messages').snapshots()) {
  //     for (var messages in snapshot.docs) {
  //       print(messages.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Chats',
            style: GoogleFonts.balooDa(
              fontSize: 30,
              //fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            // TODO Going back functionality
            Navigator.pushNamed(context, HomeScreen.id);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 23,
              color: Colors.white,
            ),
            onPressed: () {
              // TODO Sign out functionality
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MessageStream(),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: TextField(
                        controller: _textFieldEditingController,
                        onChanged: (value) {
                          //TODO For message typing
                          messageText = value; // value = Hello World!!
                        },
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF292929),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                          hintText: 'Type your message here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black87, width: 2.0),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white12, width: 2.0),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5, bottom: 5),
                    child: IconButton(
                      // TODO send button functionality (messageText + loggedInUser.email)
                      onPressed: () {
                        _textFieldEditingController.clear();
                        _fireStore.collection('messages').add({
                          'text': messageText, // Hello World!!
                          'sender': loggedInUser!.email,
                        });
                      },
                      icon: Icon(
                        Icons.navigation_rounded,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageDisplayButton extends StatelessWidget {
  final String? messageText;
  final String? senderEmail;
  final bool? isMe;

  MessageDisplayButton(
      {required this.messageText,
      required this.senderEmail,
      required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          '$senderEmail',
          style: TextStyle(
            color: Colors.white24,
            fontSize: 12,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Material(
            elevation: 200,
            color: isMe! ? Colors.blue : Colors.green,
            borderRadius: isMe!
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '$messageText',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      // snapshots basically means we have subscribed to this stream, if anything adds in to it. It will show that to us.
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messagesData = snapshot.data!.docs.reversed;
          // We can assume this as snapshot.docs.data
          List<MessageDisplayButton> textList = [];
          for (var message in messagesData) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final currentUser = loggedInUser!.email;
            if (currentUser == messageSender) {
              // Right we are sending the message and this should be in the right.
            }

            final textWidget = MessageDisplayButton(
              messageText: messageText,
              senderEmail: messageSender,
              isMe: currentUser == messageSender, // true
            );
            textList.add(textWidget);
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                reverse: true,
                children: textList,
              ),
            ),
          );
        } else {
          throw Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black54,
            ),
          );
        }
      },
    );
  }
}
