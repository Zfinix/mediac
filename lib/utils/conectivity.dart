import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

/// a base class for any statful widget for checking internet connectivity
abstract class BaseState<T extends StatefulWidget> extends State {
  ///void castStatefulWidget();

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// the internet connectivity status
  bool isOnline = true;

  /// initialize connectivity checking
  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
          isOnline = isConnected;
        }));
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
            isOnline = isConnected;
            showBar();
          }));
    });
  }

  showBar() async {
    if (!isOnline) {
      await Flushbar(
        messageText: Text(
          "No Internet Connection",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        /**/
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ).show(context);
    } else  {
      await Flushbar(
        messageText: Text(
          "Connected",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 7),
      ).show(context);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }
}
