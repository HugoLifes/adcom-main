import 'package:adcom/json/jsonAmenidades.dart';
import 'package:adcom/src/methods/eventDashboard.dart';
import 'package:adcom/src/models/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class GridDashboard extends StatefulWidget {
  final userId;
  bool? landscape = false;
  GridDashboard({this.userId, this.landscape});
  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  @override
  void initState() {
    super.initState();
  }

  Items item1 = new Items(
      title: "Mis Pagos",
      route: '/screen3',
      icon: Icon(
        Icons.show_chart_rounded,
        size: 50,
        color: Colors.lightGreen,
      ));

  Items item2 = new Items(
      title: 'Avisos',
      route: '/screen4',
      icon: Icon(Icons.announcement_rounded,
          size: 50, color: Colors.blueGrey[700]));

  Items item3 = new Items(
      title: 'Votaciones',
      //route: '/screen6',
      icon: Icon(
        Icons.book_rounded,
        size: 50,
        color: Colors.grey,
      ));

  Items item4 = new Items(
      title: 'Amenidades',
      route: '/screen7',
      icon: Icon(
        Icons.event,
        size: 50,
        color: Colors.deepPurpleAccent,
      ));

  Items item5 = new Items(
      title: 'Reportes',
      route: '/screen5',
      icon: Icon(
        Icons.report,
        size: 50,
        color: Colors.blue,
      ));

  Items item6 = new Items(
      title: 'Coming Soon',
      //route: '/screen8',
      icon: Icon(
        Icons.accessibility_new,
        size: 50,
        color: Colors.grey,
      ));

  Items item7 = new Items(
      title: 'Coming Soon',
      //route: '/screen9',
      icon: Icon(
        Icons.chat_rounded,
        size: 50,
        color: Colors.grey,
      ));

  Items item8 = new Items(
      //route: '/screen10',
      title: 'Coming Soon',
      icon: Icon(Icons.assistant, size: 50, color: Colors.grey));
  Items item9 = new Items(
    route: '/screen11',
    title: 'Directorio',
    icon: Icon(
      Icons.contacts,
      size: 50,
      color: Colors.greenAccent[700],
    ),
  );
  Items it10 = new Items(
    route: 'LOGOUT',
    title: 'Logout',
    icon: Icon(
      Icons.exit_to_app,
      size: 50,
      color: Colors.greenAccent[700],
    ),
  );
  List<Items> myList = [];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    switch (widget.userId) {
      case 1:
        myList = [item1, item5, item4, item2, it10];

        break;
      case 2:
        myList = [item9, item4, item5, item2, it10];

        break;
      case 3:
        myList = [item8, item9];
        break;
      case 4:
        myList = [item9, item4, item5, item2, it10];
        break;
    }
    return AnimationLimiter(
      child: Container(
        child: GridView.count(
            padding:
                EdgeInsets.only(left: 16, right: 16, top: size.height / 2.5),
            crossAxisCount: 2,
            childAspectRatio: widget.landscape == true ? 3.0 : 1.1,
            crossAxisSpacing: widget.landscape == true ? 16 : 15,
            mainAxisSpacing: 16,
            children: myList.map((data) {
              return AnimationConfiguration.staggeredGrid(
                columnCount: myList.length,
                duration: Duration(milliseconds: 375),
                position: 2,
                child: ScaleAnimation(
                  scale: 0.5,
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        if (data.route == "LOGOUT") {
                          Provider.of<EventProvider>(context, listen: false)
                              .logOut(context);
                        } else {
                          if (widget.userId == 4) {
                            if (data.route == '/screen5') {
                              Navigator.pushNamed(context, data.route!,
                                  arguments: GridDashboard());
                            } else {
                              Fluttertoast.showToast(msg: "No tiene acceso");
                            }
                          } else {
                            Navigator.pushNamed(context, data.route!,
                                arguments: GridDashboard());
                          }
                        }
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            data.icon!,
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              data.title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }
}

class Items {
  String? route;
  String? title;
  String? id;
  String? subtitle;
  //el evento puede ayudar a las notificaciones, checar despues
  String? event;
  Icon? icon;
  Items({this.title, this.icon, this.subtitle, this.route, this.id});
}
