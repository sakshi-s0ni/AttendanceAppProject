import 'package:attendance/screens/list.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

String dataString = "CD";

//on pressing submit, subcode and date is taken care of.
//no duplicates are allowed
class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();

  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  String time;
  String getT() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    setState(() {
      time = formattedDateTime;
    });
    // print(time);
    return time;
  }

  List dates = [];
  List codes = [];
  String codeid;

  dat() async {
    await fsconnect.collection("subcode").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (!codes.contains(element["code"])) {
          codes.add(element["code"]);
        }
        if (element["code"] == dataString) {
          codeid = element.id;
        }
      });
    });
    print(codes);
    if (!codes.contains(dataString)) {
      var docref = await fsconnect.collection("subcode").add({
        "code": dataString,
      });
      codeid = docref.id;
      print(codeid);
    } else {
      print("already existing code");
    }
    print("subcode id in generate");
    print(codeid);
    var dt = fsconnect.collection("subcode").doc(codeid).collection("date");
    await dt.get().then((querySnapshot) {
      querySnapshot.docs.forEach((res) {
        dates.add(res["dateval"]);
      });
    });
    print(dates);
    if (!dates.contains(getT())) {
      dt.add({
        "dateval": getT(),
      }).then((_) {
        print("successfully added different date");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "QR Code Generator",
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
              }),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      /* appBar: AppBar(
        title: Text('QR Code Generator'),
        
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ), */
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
      print("errrrr");
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Enter Subject Code",
                        errorText: _inputErrorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      child: Text("SUBMIT"),
                      onPressed: () {
                        setState(() {
                          dataString = _textController.text;
                          _inputErrorText = null;
                          dat();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: dataString,
                  size: 0.5 * bodyHeight,
                  /*   onError: (ex) {
                    print("[QR] ERROR - $ex");
                    setState(() {
                      _inputErrorText =
                          "Error! Maybe your input value is too long?";
                    });
                  },*/
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
