import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glyphicon/glyphicon.dart';

class MakeNewPost extends StatefulWidget {
  MakeNewPost({Key? key}) : super(key: key);

  @override
  _MakeNewPostState createState() => _MakeNewPostState();
}

class _MakeNewPostState extends State<MakeNewPost> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Post'),
        elevation: 4.0,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15),
                  child: Container(
                    height: 51,
                    width: size.width / 9,
                    decoration: BoxDecoration(
                        color: Colors.grey[300], shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 55,
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.width / 39),
                  child: Text('Administrador',
                      style: (TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "¿Algo para decir?",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Color(0xFF455A64))),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(200)])),
            SizedBox(
              height: size.width / 20,
            ),
            Divider(
              color: Color(0xFF455A64).withOpacity(0.3),
              thickness: 1.1,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Glyphicon.image,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Text(
                        'Selecciona una image',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.width / 20,
                    child: Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                      thickness: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Glyphicon.paperclip,
                        color: Colors.pink,
                        size: 25,
                      ),
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Text('Selecciona un archivo',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300))
                    ],
                  ),
                  SizedBox(
                    height: size.width / 20,
                    child: Divider(
                      color: Color(0xFF455A64).withOpacity(0.3),
                      thickness: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Glyphicon.file_earmark_pdf,
                        color: Colors.purpleAccent,
                        size: 25,
                      ),
                      SizedBox(
                        width: size.width / 20,
                      ),
                      Text('Selecciona un PDF',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
