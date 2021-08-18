import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gridDashboard.dart';

class NormalDashboard extends StatefulWidget {
  NormalDashboard({Key? key}) : super(key: key);

  @override
  _NormalDashboardState createState() => _NormalDashboardState();
}

class _NormalDashboardState extends State<NormalDashboard> {
  Items item1 = new Items(
      title: "Finanzas",
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
      route: '/screen6',
      icon: Icon(
        Icons.book_rounded,
        size: 50,
        color: Colors.cyan,
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
      title: 'Vistantes',
      route: '/screen8',
      icon: Icon(
        Icons.accessibility_new,
        size: 50,
        color: Colors.teal,
      ));
  Items item8 = new Items(
      route: '/screen10',
      title: 'Networking',
      icon: Icon(Icons.assistant, size: 50, color: Colors.red));
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item8];
    return Expanded(
        child: GridView.count(
            padding: EdgeInsets.only(left: 17, right: 17),
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: myList.map((data) {
              return InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
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
              );
            }).toList()));
  }
}
