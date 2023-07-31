import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> students = [];
List<String> roll = [];
var fsconnect = FirebaseFirestore.instance;
var authc = FirebaseAuth.instance;
List<String> func = [];
List<String> funcroll = [];

void ret() async {
  var fs = fsconnect.collection("students");
  await fs.get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result["name"]);
      if (!funcroll.contains(result["rollno"])) {
        func.add(result["name"]);
        funcroll.add(result["rollno"]);
      }
    });
  });
  students = List.from(func);
  roll = List.from(funcroll);
  print(students);
}

class MyList extends StatefulWidget {
  //const MyList({ Key? key }) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Users",
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
                // students = List.from(ret());
                // ret();
              }),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              hoverColor: Colors.black26,
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authc.signOut();
                Navigator.of(context).pushNamed('/');
                //await _googleSignIn.signOut();
              }),
          IconButton(
              color: Colors.black,
              hoverColor: Colors.black26,
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  ret();
                });
              }),
          IconButton(
              color: Colors.black,
              hoverColor: Colors.black26,
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/addstu');
              }),
        ],
      ),
      body: Center(
        child: Container(
          child: Expanded(
            child: new ListView.builder(
                itemCount: students.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(students[index]),
                      subtitle: Text(roll[index]),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
