import 'package:flutter/material.dart';

class Slide {
  String? heading;
  String image;
  String? descrip;
  CloseButton? button = CloseButton();
  Widget? titulo;
  Function? abrirCam;
  Function? abrirGal;
  Future? saveForm;
  final titleController = TextEditingController();

  Slide(
      {this.button,
      this.titulo,
      this.image = '',
      this.abrirCam,
      this.abrirGal,
      this.descrip,
      this.saveForm,
      this.heading});
}
