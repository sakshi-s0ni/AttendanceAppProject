import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var fsconnect = FirebaseFirestore.instance;
var authc = FirebaseAuth.instance;
bool _obscureText = true;
var displayName;
var url =
    "https://www.dicoding.com/images/original/event/dsc_chapter_stmik_stikom_indonesia_introducing_developer_student_club_and_google_technologies_logo_041019113915.png";

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String password;
  String email;
  var url =
      "https://www.dicoding.com/images/original/event/dsc_chapter_stmik_stikom_indonesia_introducing_developer_student_club_and_google_technologies_logo_041019113915.png";

  @override
  Widget build(BuildContext context) {
    //var msgtextcontrollerpass = TextEditingController();
    // var msgtextcontrolleruser = TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        /* leading: new Container(
          padding: new EdgeInsets.all(8.0),
          width: 15.0,
          height: 15.0,
          child: CircleAvatar(child: Image(image: NetworkImage(url))),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),*/
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                //controller: msgtextcontrolleruser,
                decoration: InputDecoration(hintText: "Enter email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 30),
              TextField(
                //controller: msgtextcontrollerpass,
                obscureText: _obscureText,
                decoration: InputDecoration(hintText: "Enter password"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 20),
              Material(
                color: Colors.blueAccent,
                elevation: 5,
                borderRadius: BorderRadius.circular(5),
                child: MaterialButton(
                  onPressed: () async {
                    await authc.signInWithEmailAndPassword(
                        email: email, password: password);
                    User user = authc.currentUser;
                    print(user);
                    try {
                      if (user != null) {
                        //Navigator.pushNamed(context, '/list');
                        Navigator.of(context).pushNamed('/admin');
                      }
                    } catch (e) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Wrong email or password"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      print(e);
                    }
                  },
                  child: Text("Login"),
                ),
              ),
              SizedBox(height: 25),
              Text("Don't have an account? "),
              FlatButton(
                onPressed: () async {
                  int indexForProf = email.lastIndexOf('@');
                  String profChck = email.substring(indexForProf, email.length);
                  print(profChck);
                  if (profChck != "@prof.mbm") {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text("Wrong email or password"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                  if (profChck == "@prof.mbm") {
                    try {
                      var user = await authc.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      int ind = email.lastIndexOf('@');
                      displayName = email.substring(0, ind);
                      var idd = authc.currentUser;
                      print(user);
                      fsconnect.collection("users").doc(idd.uid).set({
                        "name": displayName,
                        "email": email,
                      }).then((_) {
                        print("successfully added new professor!");
                      });
                      if (user.additionalUserInfo.isNewUser == true) {
                        Navigator.pushNamed(context, '/admin');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
