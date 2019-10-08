import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediac/utils/base64/images.dart';
import 'package:mediac/utils/conectivity.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';

//Notifications Page
class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends BaseState<Notifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  List<NotifItem> notifData = [];

//Initializing the
  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    //  load();

    inim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            'Schedule Checkups',
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.white.withOpacity(0.953), BlendMode.screen),
              image: MemoryImage(base64.decode('$base64Image')),
            ),
          ),
          child: Center(
              child:
                  notifData == null || notifData == [] || notifData.length > 0
                      ? ListView.builder(
                          itemCount: notifData?.length ?? 0,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                      title: Text(
                                        notifData[i].title ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        notifData[i].body ?? '',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () => _deleteNotif(i),
                                      )),
                                  Divider()
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('You Have No Pending Appointments')
                            ],
                          ),
                        )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async => await _showDialog(),
        ));
  }

  _deleteNotif(i) {
    if (i != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            title: Center(child: Text('Alert')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Do you want to remove this Checkup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    setState(() {
                      notifData.removeAt(i);
                    });

                    saveNotifItems(notifs: Notify(data: notifData));
                    Navigator.of(context).pop();
                  })
            ],
          );
        },
      );
    }
  }

  _showDialog() async {
    DateTime notifTime = DateTime.now();
    var title, body;

    _buildDate() => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.95,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  notifTime = value;
                });
              },
              initialDateTime: DateTime.now(),
              minimumDate: DateTime.now().subtract(Duration(days: 1)),
              maximumDate: null),
        );

    await showDialog<String>(
        context: context,
        builder: (_) {
          return new AlertDialog(
            elevation: 0,
            contentPadding: const EdgeInsets.all(16.0),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new TextField(
                        autofocus: true,
                        onChanged: (v) {
                          setState(() {
                            title = v;
                          });
                        },
                        decoration: new InputDecoration(
                            labelText: 'Title',
                            hintText: 'eg. Meeting with Doctor John'),
                      ),
                      cYM(10),
                      new TextField(
                        onChanged: (v) {
                          setState(() {
                            body = v;
                          });
                        },
                        decoration: new InputDecoration(
                            labelText: 'Extra Info',
                            hintText: 'eg. Eye Checkup'),
                      ),
                    ],
                  ),
                  _buildDate()
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('ADD NEW CHECKUP'),
                  onPressed: () async {
                    if (title != null) {
                      await addNotification(NotifItem(
                          id: (notifData?.length ?? 0) + 1,
                          title: title,
                          body: body,
                          date: notifTime.toIso8601String(),
                          payload: body));
                      Navigator.pop(context);
                    }
                  })
            ],
          );
        });
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

  Future addNotification(NotifItem notif) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Notificaions', '${notif.title}', '${notif.body}',

        // vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0,
        '${notif?.title ?? ''}',
        '${notif?.body ?? ''}',
        DateTime.parse(notif.date),
        platformChannelSpecifics,
        payload: notif?.payload ?? '',
        androidAllowWhileIdle: true);

    if (notifData != null)
      setState(() {
        notifData.add(notif);
      });
    else
      setState(() {
        notifData?.add(notif);
      });

    saveNotifItems(notifs: Notify(data: notifData));
  }

  void inim() async {
    try {
      /* var pendingNotificationRequests = */
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

      var items = await loadNotifItems();
      print(items?.data.toString());
      if (items != null && items?.data != null) {
        setState(() {
          notifData = items?.data;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class Notify {
  List<NotifItem> data;

  Notify({this.data});

  Notify.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NotifItem>();
      json['data'].forEach((v) {
        data.add(new NotifItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data["data"] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotifItem {
  int id;
  String title, body, payload;
  String date;

  NotifItem({
    this.id,
    this.title,
    this.body,
    this.payload,
    this.date,
  });

  NotifItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    payload = json['payload'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['payload'] = this.payload;
    data['date'] = this.date;
    return data;
  }
}
