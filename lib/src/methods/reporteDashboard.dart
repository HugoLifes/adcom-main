import 'package:adcom/json/jsonReporte.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
int? initScreen;

class ReportesDashboard extends StatefulWidget {
  const ReportesDashboard({Key? key}) : super(key: key);

  @override
  _ReportesDashboardState createState() => _ReportesDashboardState();
}

class _ReportesDashboardState extends State<ReportesDashboard> {
  @override
  void initState() {
    super.initState();
  }

  Items2 item1 = new Items2(
      title: "Reportar evento inusual",
      route: '/screen17',
      icon: Icon(
        Icons.warning,
        size: 30,
        color: Colors.red,
      ));

  Items2 item2 = new Items2(
      title: 'Seguimiento de reporte',
      route: '/screen14',
      icon: Icon(Icons.follow_the_signs, size: 30, color: Colors.blue[600]));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Items2> myList = [
      item1,
      item2,
    ];
    return Flexible(
        child: GridView.count(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            crossAxisCount: 1,
            childAspectRatio: 3.5,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: myList.map((data) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, data.route!);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 5))
                      ]),
                  child: Container(
                    //margin: EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300], shape: BoxShape.circle),
                          child: data.icon,
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              data.title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width / 25,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList()));
  }
}

class Items2 {
  String? route;
  String? title;
  String? numero;
  String? id;
  String? subtitle;
  //el evento puede ayudar a las notificaciones, checar despues
  String? event;
  Icon? icon;
  Items2(
      {this.title, this.icon, this.subtitle, this.route, this.id, this.numero});
}