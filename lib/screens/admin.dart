import 'package:flutter/material.dart';

class MyAdmin extends StatefulWidget {
  //const MyAdmin({ Key? key }) : super(key: key);

  @override
  _MyAdminState createState() => _MyAdminState();
}

List<String> opt = [
  "Students Info",
  "Generate QR",
  "Scan QR",
  "Show Attendance"
];
List<String> routes = ["/list", "/gen", "/scan", "/showat"];

class _MyAdminState extends State<MyAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Attendance",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: new Container(
          padding: new EdgeInsets.all(8.0),
          width: 15.0,
          height: 15.0,
          child: IconButton(
              color: Colors.black,
              hoverColor: Colors.black26,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                //print(students);
              }),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: new ListView.builder(
              itemCount: opt.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, routes[index]);
                        },
                        child: Text(opt[index])),
                    // subtitle: Text(subtitles[index]),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
