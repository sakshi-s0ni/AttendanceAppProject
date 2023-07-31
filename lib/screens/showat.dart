import 'package:attendance/screens/datepg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var fsconnect = FirebaseFirestore.instance;
var authc = FirebaseAuth.instance;
List<String> codes = [];
List<String> subcodeids = [];
int count = 0;
subjects() async {
  await fsconnect.collection("subcode").get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      if (codes.contains(element["code"]) == false) {
        codes.add(element["code"]);
        subcodeids.add(element.id);
        count++;
      }
    });
  });
}

class ShowAt extends StatefulWidget {
  //const ShowAt({Key? key}) : super(key: key);

  @override
  _ShowAtState createState() => _ShowAtState();
}

class _ShowAtState extends State<ShowAt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Subject",
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
                await subjects();
              }),
        ],
      ),
      body: buildListView(context),
    );
  }
}

ListView buildListView(BuildContext context) {
  return ListView.builder(
    itemCount: count,
    itemBuilder: (_, index) {
      return ListTile(
        title: Text(codes[index]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DatePg(index, subcodeids[index])));
        },
      );
    },
  );
}

/*
Widget getHistory() {
		return StreamBuilder<QuerySnapshot> (
			stream: Firestore.instance.collection('subcode').document(_subject.studentDocumentId).collection('subject').document(_subject.documentId).collection('attendance').orderBy("date", descending: true).snapshots(),
			builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
				if(!snapshot.hasData)
					return Text('Loading');
				return getHistoryList(snapshot);
			},
		);
	}

	//Returns the attendance as a list view
	getHistoryList(AsyncSnapshot<QuerySnapshot> snapshot) {
		var listView = ListView.builder(itemBuilder: (context, index) {
			if(index<snapshot.data.documents.length) {
				var doc = snapshot.data.documents[index];
				Attendance attendance = Attendance.fromMapObject(doc);
				attendance.documentId = doc.documentID;
				attendance.studentDocumentId = _subject.studentDocumentId;
				attendance.subjectDocumentId = _subject.documentId;
				return Card(
					child: ListTile(
						leading: attendance.outcome == 'P' ?
						Container(
							margin: EdgeInsets.all(15.0),
							width: 10.0,
							height: 10.0,
							decoration: BoxDecoration(
								shape: BoxShape.circle,
								color: Colors.green
							),
						):
						Container(
							margin: EdgeInsets.all(15.0),
							width: 10.0,
							height: 10.0,
							decoration: BoxDecoration(
								shape: BoxShape.circle,
								color: Colors.red,
							),
						),
						title: Text(attendance.date),
						trailing: Text(attendance.duration+' Hours'),
					),
				);
			}
		});
		return listView;
	}
}*/
