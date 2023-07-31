import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:attendance/screens/list.dart' as list;

bool _obscureText = true;
var displayn;

class AddStu extends StatefulWidget {
  //const AddStu({ Key? key }) : super(key: key);

  @override
  _AddStuState createState() => _AddStuState();
}

class _AddStuState extends State<AddStu> {
  String password;
  var fsconnect = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;
  String email;
  var rno;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: new Container(
          padding: new EdgeInsets.all(8.0),
          width: 15.0,
          height: 15.0,
          // child: CircleAvatar(child: Image(image: NetworkImage(url))),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),
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
              SizedBox(height: 30),
              TextField(
                //controller: msgtextcontrolleruser,
                decoration: InputDecoration(hintText: "Roll Number"),
                // keyboardType: TextInputType.number,
                onChanged: (value) {
                  rno = value;
                },
              ),
              SizedBox(height: 30),
              FlatButton(
                onPressed: () async {
                  try {
                    var user = await authc.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    print(email);
                    print(password);
                    print(user);
                    int ind = email.lastIndexOf('@');
                    displayn = email.substring(0, ind);

                    if (user.additionalUserInfo.isNewUser == true) {
                      //list.students.add(displayn);
                      fsconnect
                          .collection("students")
                          .doc(authc.currentUser.uid)
                          .set({
                        "name": displayn,
                        "email": email,
                        "rollno": rno,
                        "mark": "0",
                      }).then((_) {
                        print("Successfully added!!");
                      });
                      Navigator.pushNamed(context, '/list');
                    }
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("User Already Exists!"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    print(e);
                  }
                },
                child: Text("Add"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
