
import 'package:adcom/src/extra/reporte.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

// ignore: must_be_immutable
class ReportEditPage extends StatefulWidget {
  final DataReporte report;
  final int ? id;
  final List<Progreso>? data;
  Map<dynamic, Map>? progreso;
  Map<dynamic, Map>?datos;
  Map? superMap = <dynamic, Map>{};
  Map<dynamic, Map>? fechas;
  
  
  ReportEditPage({Key? key, required this.report, required this.data, this.progreso, this.fechas, this.datos, this.superMap, this.id}) : super(key: key);

  @override
  _ReportEditPageState createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  int _activeStep = 0;

  List<dynamic> progreso = [];
  var data;
  List<ProgressIndicator> progres = [];
  List<DatosProgreso> datosp = [];
  bool finalizado = false;
  List<FechaReporte> f = [];
  int ? estatusP;


  estatus() {
    widget.progreso!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Progreso') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                print('progreso: ${value}');
                value.sort();
                progres.add(new ProgressIndicator(id: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }

  datos() {
    widget.datos!.forEach((key, value) {
      if (widget.id == key) {
        value.forEach((key, value) {
          if (key == 'Datos') {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                print('progreso: ${value}');
                datosp.add(new DatosProgreso(coment: value[i]));
              }
            });
          }
        });
      } else {
        return;
      }
    });
  }
  
  fechasR(){
    widget.fechas!.forEach((key, value) {
      if(widget.id == key){
        value.forEach((key, value) {
          if(key == 'Fechas'){
            setState(() {
              for(int i = 0; i< value.length; i++){
                f.add(new FechaReporte(
                  f: value[i]
                ));
              }
            });
          }
        });
      }else{
        return ;
      }
     });
  }
  
  @override
  void initState() {
    estatus();
    datos();
    fechasR();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    //var size2 = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Seguimiento de reporte'),
          backgroundColor: Colors.blue,
          leading: CloseButton(),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              IconStepper(
                enableStepTapping: isFinalizado(),
                icons: [
                  Icon(Icons.supervised_user_circle),
                  Icon(Icons.check),
                  Icon(Icons.flag),
                  Icon(Icons.access_alarm),
                  Icon(Icons.check)
                ],
                activeStep: progres.isEmpty ? 0 : progres.last.id,
                onStepReached: (index) {
                  setState(() {
                    if(progres.isEmpty){
                      _activeStep = index;
                    }else{
                      progres.last.id = index;
                      
                    }
                  });
                },
              ),
              header(),
              SizedBox(
                height: 10,
              ),
              help(),
              
              plainText(size)
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
          color: stepColor()!, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(9.0),
            child: Text(
              'Status: ${headerText()!}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

 Widget plainText(size) {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
     
        return datosp.isEmpty? Container( child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asesor:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tu reporte se encuentra en revision',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        ),) :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           

            Container(
              padding: EdgeInsets.only(left: size/15),
              child: Text('Comentarios:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
            ),
            respuestaView(size),
          ],
        );  
      case 2:
    
        return datosp.isEmpty? Container( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asesor:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tu reporte se encuentra en revision',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        ),) :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           

          
            Container(
              padding: EdgeInsets.only(left: size/15),
              child: Text('Seguimiento:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
            ),
            respuestaView(size),
          ],
        );
      case 3:
  
        return datosp.isEmpty? Container( child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asesor:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'No hay comentarios',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        ),) :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           Container(
             padding: EdgeInsets.only(left: size/15),
             child: Text('Seguimiento:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
           ),

            

            respuestaView(size),
          ],
        );
      case 4:
        
       
        return datosp.isEmpty? Container( child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text('Asesor:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              'Tu reporte se ha atendido y ha finalizado con éxito',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            )
          ],
        ),) :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Container(
             padding: EdgeInsets.only(left: size/15),
             child: Text('Seguimiento:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
           ),
            respuestaView(size),
          ],
        );
      default:
        return Container();
    }
  }

 ListView respuestaView(size) {
   return ListView.builder(
            padding: EdgeInsets.only(left: size/ 4.3, top:10),
            shrinkWrap: true,
            itemCount: datosp.length,
            itemBuilder: (_,int index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text('${f[index].f!.day}/${f[index].f!.month}/${f[index].f!.year}'),
                SizedBox(
                  height: 5,
                ),
                SizedBox(width: size/2, child: Text(datosp[index].coment, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),

              ],
            );
          });
 }
  Color? stepColor() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.lightGreen[200];
      case 3:
        return Colors.lightGreen[300];
      case 4:
        return Colors.lightGreen;

      default:
        return Colors.grey;
    }
  }

  bool isFinalizado(){
    if(progres.isNotEmpty){
      if(progres.last.id == 4){
        setState(() {
          finalizado = true;
        });
          
      }else{
        finalizado = false;
      }
    }
    return finalizado;
  }

  String? headerText() {
    switch (progres.isEmpty ? 0 : progres.last.id) {
      case 1:
        return 'Revisión';
      case 2:
        return 'En proceso';
      case 3:
        return 'Respuesta';
      case 4:
        return 'Finalizado';
      default:
        return 'Enviado';
    }
  }
  

  buildImage() => GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 150,
            mainAxisSpacing: 12,
            crossAxisSpacing: 7,
            childAspectRatio: 1.1),
        itemCount: widget.report.uri!.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(widget.report.uri![index]);
        },
      );

  help() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.report.descripCorta!,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(right: 170),
                child: Text(
                  widget.report.desperfecto!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              buildImage(),
            ],
          ),
        )
      ],
    );
  }
}

class ProgressIndicator{
  var id;
  ProgressIndicator({this.id});
}
class DatosProgreso{
  var coment;

  DatosProgreso({this.coment});
}
class FechaReporte{
  DateTime? f;

  FechaReporte({this.f});
}