import 'package:adcom/src/methods/dashboard_chat.dart';
import 'package:adcom/src/methods/searchBar.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final id;
  Chat({Key? key, this.id}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * .40,
            decoration: BoxDecoration(color: Colors.deepOrange),
          ),
          Container(
            padding: EdgeInsets.only(top: 75),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.chat_rounded,
              color: Colors.white,
              size: 170,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Chat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Atencion a residentes',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * .55,
                child: Text(
                  'Habla directamente con el administrador de tu residencia si tienes algun problema o necesitas ayuda',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: size.width * .5,
                child: SearchBar(),
              ),
              ChatDashboard()
            ]),
          ))
        ],
      ),
    );
  }
}
