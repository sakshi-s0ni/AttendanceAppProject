import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'generate.dart' as gen;

//prblm is with dteid, usko last mein use krre h vha
var fsconnect = FirebaseFirestore.instance;
var authc = FirebaseAuth.instance;
var user = authc.currentUser;
void mark() async {
  // print(user.email);
  await fsconnect.collection("students").doc(user.uid).update({
    "mark": "123",
  }).then((_) {
    print("success!");
  });
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

String _timeString;
String subid = ""; //subject code's document id so that we can
//proceed further to add date collectio to it.
String dteid = ""; //same goes for this also, date's document id

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  String _getTime() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
    print(_timeString);
    return _timeString;
  }

//code to get doc ids of collections
  List<String> subidlist = [];
  List<String> dtidlist = [];
  var fst = fsconnect.collection("subcode");

  int count = -1;
  int c = -1;
  Future<String> subcodid() async {
    var reqsubid;
    await fst.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        count = count + 1;
        if (!subidlist.contains(result.id)) {
          subidlist.add(result.id);
        }
        if (result["code"] == gen.dataString) {
          reqsubid = result.id;
        }
      });
    });
    print("subcode idsss-");
    print(subidlist);
    //return subidlist;
    setState(() {
      subid = reqsubid;
    });
    print("requested subcode id " + subid);
    return reqsubid;
  }

  Future<String> dateid() async {
    var reqdtid;
    var dt = fsconnect.collection("subcode").doc(subid).collection("date");
    await dt.get().then((querySnapshot) {
      querySnapshot.docs.forEach((res) {
        print(res["dateval"]);
        if (!dtidlist.contains(res.id)) {
          dtidlist.add(res.id);
        }
        if (res["dateval"] == _getTime()) {
          reqdtid = res.id;
        }
      });
      print("dateidsss- ");
      print(dtidlist);
    });
    // return dtidlist;
    setState(() {
      dteid = reqdtid;
    });
    print("requested date id " + dteid);
    return reqdtid;
  }

//adding any kind of data is done in this function
  int doadd = 0; //to chck if subject code is present in docs

  void afterscan() async {
    //fst = goes till subcode collection
    print(gen.dataString);
    await fst.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result["code"] == gen.dataString) {
          doadd = 1;
        }
      });
    });
    if (doadd == 0) {
      await fsconnect.collection("subcode").add({
        "code": gen.dataString,
      }).then((_) {
        print("success for subcode!");
      });
      /*  await fsconnect
          .collection("subcode")
          .doc(subid)
          .collection("date")
          .add({"dateval": _getTime()}).then((_) {
        print("success for 1st dateval!");
      }); */
    }
    //subject code id if it is already present in database
    var subcmp = await subcodid();
    print("subject code doc id is:  ");
    print(subcmp);

    //from here on checking for date ids

    bool addDatebool = true;

    var dd = fsconnect.collection("subcode").doc(subid).collection("date");
    await dd.get().then((querySnapshot) {
      querySnapshot.docs.forEach((res) {
        if (res["dateval"] == _getTime()) {
          setState(() {
            addDatebool = false;
            print(addDatebool);
          });
        }

        /*else if (did) {
          setState(() {
            addDatebool = false;
          });
        }*/
      });
    });

    /* bool dtidlistd = false; //dtidlistd is to chck if dte not in collection
    //dteid is date id if it is already in collection
    if (dteid == "") {
      dtidlistd = true;
    } */
    //this if is to chck if date is not in collection then add it
    if (addDatebool) {
      await dd.add({
        "dateval": _getTime(),
      }).then((_) {
        print("success for date val!");
      });
    }
    var datcmp = await dateid();
    print("date doc id is : ");
    print(datcmp);
    //this is to chck if student has scanned once then
    //no need to add them again for same subject
    bool studFlag = true;
    await fsconnect
        .collection("subcode")
        .doc(subid)
        .collection("date")
        .doc(dteid)
        .collection("pstu")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result["stud"] == authc.currentUser.email) {
          studFlag = false;
          print("curr user is ");
          print(authc.currentUser.email);
        }
      });
    });
    if (studFlag) {
      await fsconnect
          .collection("subcode")
          .doc(subid)
          .collection("date")
          .doc(dteid)
          .collection("pstu")
          .add({
        "stud": user.email,
      }).then((_) {
        print("success for pstud!");
      });
    }
  }
  //after scan function ends here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Scanner",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // mark();
                afterscan();
                _getTime();
              },
              icon: Icon(
                Icons.account_box,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeSanner =
                    await BarcodeScanner.scan(); //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
                  // mark();
                  afterscan();
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }
              },
              child: Text(
                "Click To Scan",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
