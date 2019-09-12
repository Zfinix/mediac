import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediac/auth/signup.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'auth/login.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediac',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Eina03',
        primarySwatch: Colors.blue,
      ),
      home: Intersit(),
    );
  }
}

class Intersit extends StatefulWidget {
  Intersit({Key key}) : super(key: key);

  _IntersitState createState() => _IntersitState();
}

class _IntersitState extends State<Intersit> {
  Widget page;
  double opacity = 1;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    setState(() {
      page = IntersitPage(changeView);
    });
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    inim();
  }

  void inim() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            child: page,
            opacity: opacity),
      ),
    );
  }

  void changeView(Widget val) async {
    setState(() {
      opacity = 0;
    });
    await Future.delayed(new Duration(seconds: 1));
    setState(() {
      page = val;
    });
    setState(() {
      opacity = 1;
    });
  }
}

class IntersitPage extends StatefulWidget {
  const IntersitPage(
    this.changeView, {
    Key key,
  }) : super(key: key);
  final Function changeView;

  @override
  _IntersitPageState createState() => _IntersitPageState();
}

class _IntersitPageState extends State<IntersitPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/images/mediac2.png'),
        cYM(20),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            'Hi are you feeling Down? Mediac can help.',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ),
        cYM(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                OutlineButton(
                  highlightColor: Colors.white24,
                  color: Colors.blue,
                  textColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    this.widget.changeView(Signup(widget.changeView));
                  },
                  child: Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                OutlineButton(
                  highlightColor: Colors.white24,
                  color: Colors.blue,
                  textColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    this.widget.changeView(Login(widget.changeView));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        cYM(30),
        Text(
          'Mediac',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        )
      ],
    );
  }
}
