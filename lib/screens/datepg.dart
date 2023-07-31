import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var fsconnect = FirebaseFirestore.instance;
var authc = FirebaseAuth.instance;
List<String> dates = [];
int counter = 0;

//thing to make chnges here:
//1. date list mein hr baar null se start honi chahiye
//2. pstud vali collection ko ignore krwana h
//then hr ek date pe click krne se pstud vali list aae
class DatePg extends StatefulWidget {
  // const DatePg({ Key? key }) : super(key: key);
  final int index;
  final String id;
  DatePg(this.index, this.id);
  @override
  _DatePgState createState() => _DatePgState();
}

class _DatePgState extends State<DatePg> {
  @override
  Widget build(BuildContext context) {
    // String i = widget.index.toString();
    String id = widget.id;

    dateids() async {
      dates.clear();
      await fsconnect
          .collection("subcode")
          .doc(id)
          .collection("date")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          //print(element["pstu"]);
          print(element.id);
          if (!(element["pstu"] || element["date"])) {
            if (dates.contains(element["dateval"]) == false) {
              dates.add(element["dateval"]);
              counter++;
            }
          }
        });
      });
      print(dates);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Dates",
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
              icon: Icon(Icons.refresh),
              onPressed: () async {
                // Navigator.of(context).pushNamed('/addstu');
                await dateids();
              }),
        ],
      ),
      body: buildListView(context),
    );
  }
}

String wait = "please wait";
ListView buildListView(BuildContext context) {
  return ListView.builder(
    itemCount: counter,
    itemBuilder: (_, index) {
      return ListTile(
        title: Text(dates.isEmpty ? wait : dates[index]),
        /* onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DatePg(index, [index])));
        }, */
      );
    },
  );
}
