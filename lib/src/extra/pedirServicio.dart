import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

class PedirServicio extends StatefulWidget {
  const PedirServicio({Key? key}) : super(key: key);

  @override
  _PedirServicioState createState() => _PedirServicioState();
}

class _PedirServicioState extends State<PedirServicio> {
  int _currentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final cantidadController = TextEditingController();
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Datos para el servicio',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Theme(
          data: ThemeData(
              primaryColor: Colors.red[900], primarySwatch: Colors.orange),
          child: stepper()),
    );
  }

  Stepper stepper() {
    return Stepper(
      steps: _stepper()!,
      physics: ClampingScrollPhysics(),
      currentStep: this._currentStep,
      onStepTapped: (step) {
        setState(() {
          this._currentStep = step;
        });
      },
      onStepContinue: () {
        setState(() {
          if (this._currentStep < this._stepper()!.length - 1) {
            this._currentStep = this._currentStep + 1;
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (this._currentStep > 0) {
            this._currentStep = this._currentStep - 1;
          } else {
            this._currentStep = 0;
          }
        });
      },
    );
  }

  List<Step>? _stepper() {
    List<Step> _steps = [
      Step(
          title: Text('Nombre del residente'),
          isActive: _currentStep >= 0,
          state: StepState.complete,
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: buildTitle(),
              ),
            ],
          )),
      Step(
          title: Text('Direccion de comunidad'),
          isActive: _currentStep >= 1,
          state: StepState.disabled,
          content: Column(
            children: [
              Form(
                key: _formKey2,
                child: buildComents(),
              ),
            ],
          )),
      Step(
          title: Text('Cantidad y Tipo de pago'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey3,
                child: buildCantidad(),
              ),
              Column(
                children: [
                  _lights == true ? Text('Terminal') : Text('Efectivo'),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _lights = !_lights;
                      });
                    },
                    child: CupertinoSwitch(
                      value: _lights,
                      onChanged: (bool value) {
                        setState(() {
                          _lights = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          state: StepState.disabled,
          isActive: _currentStep >= 2)
    ];
    return _steps;
  }

  buildCantidad() => Container(
        width: 200,
        child: TextFormField(
          cursorColor: Colors.black,

          onFieldSubmitted: (_) => {},
          //el controlles accede a propiedades como el texto
          controller: cantidadController,
          style: TextStyle(fontSize: 20),
          validator: (title) => title != null && title.isEmpty
              ? 'Este campo no puede estar vacio'
              : null,
          decoration: InputDecoration(
              icon: Icon(Icons.receipt),
              border: UnderlineInputBorder(),
              hintText: 'Monto en pesos'),
        ),
      );

  buildTitle() => TextFormField(
        cursorColor: Colors.black,

        onFieldSubmitted: (_) => {},
        //el controlles accede a propiedades como el texto
        controller: titleController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            border: UnderlineInputBorder(),
            hintText: 'Nombre Completo'),
      );
// funcion que construye los comentarios
  buildComents() => TextFormField(
        cursorColor: Colors.black,
        onFieldSubmitted: (_) => {},
        controller: descriptionController,
        style: TextStyle(fontSize: 20),
        validator: (title) => title != null && title.isEmpty
            ? 'Este campo no puede estar vacio'
            : null,
        decoration: InputDecoration(
            icon: Icon(Icons.receipt),
            //suffixIcon: Icon(Icons.check_circle_outline_sharp),
            helperText: 'Comente lo sucedido',
            border: UnderlineInputBorder(),
            hintText: 'Direccion'),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        inputFormatters: [new LengthLimitingTextInputFormatter(200)],
      );
}
