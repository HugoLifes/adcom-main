import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(29.5)),
      child: TextField(
        onChanged: (text) {
          text = text.toLowerCase();
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Buscar',
            icon: Icon(Icons.search)),
      ),
    );
  }
}
