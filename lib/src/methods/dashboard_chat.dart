import 'package:flutter/material.dart';

class ChatDashboard extends StatefulWidget {
  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> {
  Items item1 = new Items(
      title: "Marcos",
      numero: '332315487',
      route: '/screen15',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.lightGreen,
      ));

  Items item2 = new Items(
      title: 'Emmanuel',
      route: '/screen15',
      numero: '614558978',
      icon: Icon(Icons.person, size: 30, color: Colors.blueGrey[700]));

  Items item3 = new Items(
      title: 'Sonia',
      numero: '61454563335',
      route: '/screen15',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.cyan,
      ));

  Items item4 = new Items(
      title: 'Alma',
      numero: '13213213131',
      route: '/screen15',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.deepPurpleAccent,
      ));

  Items item5 = new Items(
      title: 'Juan',
      numero: '5645645656',
      route: '/screen15',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.blue,
      ));

  Items item6 = new Items(
      numero: '56465465465',
      route: '/screen15',
      title: 'Paco',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.teal,
      ));

  Items item7 = new Items(
      numero: '4546321648',
      route: '/screen15',
      title: 'Amlo',
      icon: Icon(
        Icons.person,
        size: 30,
        color: Colors.deepOrange,
      ));

  Items item8 = new Items(
      numero: '124687879',
      route: '/screen15',
      title: 'Elba Ester Gordillo',
      icon: Icon(Icons.person, size: 30, color: Colors.red));

  Items item9 = new Items(
    numero: '632154563',
    route: '/screen15',
    title: 'Carlos Slim',
    icon: Icon(
      Icons.person,
      size: 30,
      color: Colors.greenAccent[700],
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8,
      item9
    ];
    return Flexible(
        child: GridView.count(
            padding: EdgeInsets.only(left: 17, right: 17, top: 17),
            crossAxisCount: 1,
            childAspectRatio: 3.6,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text('${data.numero}')
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

navegar(BuildContext context, String route) {
  Navigator.pushNamed(context, route);
}

class Items {
  String? route;
  String? title;
  String? numero;
  String? id;
  String? subtitle;
  //el evento puede ayudar a las notificaciones, checar despues
  String? event;
  Icon? icon;
  Items(
      {this.title, this.icon, this.subtitle, this.route, this.id, this.numero});
}
