import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ReadText.dart';
import 'SpeakText.dart';

class ContactPage extends StatefulWidget {
  final PageController controller;

  ContactPage({Key key, @required this.controller}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState(controller);
}

class _ContactPageState extends State<ContactPage> {
  final PageController controller;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const phoneCall = const MethodChannel('samples.flutter.dev/phoneCall');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  final List<String> contacts = [
    'Ken',
    'Nikhil',
    'Saran'
  ];
  var readText = ReadText();
  var speakText = SpeakText();
  var contactsText = "You have 6 available contacts." +
      "Katie." +
      "Ken." +
      "Mark." +
      "Nikhil." +
      "Ricardo" +
      " and." +
      "Saran." +
      "Who would you like to call?";

  _ContactPageState(this.controller);

  Future<void> _makePhoneCall() async {
    try {
      final int result = await phoneCall.invokeMethod('makePhoneCall');
      print(result);
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
    });
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  initState() {
    super.initState();
    readText.initTts();
    speakText.initSpeechRecognizer();
    speakText.speechRecognition.setRecognitionCompleteHandler(
      () => this.printFinalText(),
    );
  }

  void printFinalText() {
    speakText.setListening(false);
    var userQuery = speakText.resultText.toLowerCase();

    print("User said: " + userQuery);
    if ((userQuery.contains("read") || userQuery.contains("list")) &&
        userQuery.contains("contacts")) {
      print("Reading all contacts");
      readText.speak(contactsText);
    } else if (userQuery.contains("call")) {
      print("Calling: ");
      if (userQuery.contains("katie")) {
        readText.speak("Calling Katie");
        launch("tel://3033593843");
      } else if (userQuery.contains("ken")) {
        readText.speak("Calling Ken");
        launch("tel://3033593843");
      } else if (userQuery.contains("mark")) {
        readText.speak("Calling Mark");
        launch("tel://3033593843");
      } else if (userQuery.contains("nikhil")) {
        readText.speak("Calling Nikhil");
        launch("tel://3033593843");
      } else if (userQuery.contains("ricardo")) {
        readText.speak("Calling Ricardo");
        launch("tel://3033593843");
      } else if (userQuery.contains("saran")) {
        readText.speak("Calling Saran");
        launch("tel://3033593843");
      } else {
        readText.speak(
            "Sorry, I could not understand. Please say something like. call mark.");
      }
    } else if (userQuery.contains("go") ||
        userQuery.contains("to") ||
        userQuery.contains("direction")) {
      print("Going to location");
      if (userQuery.contains("camera")) {
        readText.speak("Loading Object Recognition Software");

        controller.jumpToPage(3);
      } else if (userQuery.contains("location")) {
        readText.speak("Loading Locations Page");

        controller.jumpToPage(1);
      } else if (userQuery.contains("contacts")) {
        readText.speak("Loading Contacts");

        controller.jumpToPage(0);
      } else {
        readText.speak(
            "Sorry, I could not understand your command. Please say something like reed all contacts. call mark. or go to locations page.");
      }
    } else {
      readText.speak(
          "Sorry, I could not understand your command. Please say something like reed all contacts. call mark. or go to locations page.");
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    readText.flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return new Scaffold(
        backgroundColor: Colors.cyanAccent[700],
        body: Column(children: <Widget>[
          RaisedButton(
            child: Text('Get Battery Level'),
            onPressed: _getBatteryLevel,
          ),
          Text(_batteryLevel),
          RaisedButton(
            child: Text('Make Phone Call'),
            onPressed: _makePhoneCall,
          ),
          Expanded(
            child: new Container(
              child: new ListView.builder(
                reverse: false,
                itemBuilder: (_, int index) => EachList(this.contacts[index]),
                itemCount: this.contacts.length,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            // color: Colors.blue,
            height: _size.height * 0.25,
            // Take 25% width of the screen height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: _size.width * 0.5,
                  height: double.infinity,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Voice Commands',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      readText.stop();
                      print("Speech to text");
                      speakText.speechRecognition
                          .listen(locale: "en_US")
                          .then((result) => {});
                    },
                  ),
                ),
                SizedBox(
                  width: _size.width * 0.5,
                  height: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      'Read Contacts',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      print("Text to speech");
                      readText.speak(contactsText);
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          )
        ]));
  }
}

class EachList extends StatelessWidget {
  final String name;

  EachList(this.name);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return new GestureDetector(
      onTap: () {
        launch("tel://2142188976");
      },
      child: new Card(
        child: new Container(
          padding: EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              new CircleAvatar(
                child: new Text(name[0]),
              ),
              new Padding(padding: EdgeInsets.only(right: 10.0)),
              new Text(
                name,
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
