import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:push_notification/push_notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);

  runApp(MyApp());
}

late Notificator notification;
String notificationKey = 'key';
bool flag = false;

void onConnect(StompFrame frame) {
  print("Connected");
  stompClient.subscribe(
      destination: '/user/queue/new-order',
      callback: (frame) {
        // List<dynamic>? result = json.decode(frame.body!);
        // print(result);
        // flag = true;
        // print(flag);
        notification.show(
          1,
          'hello',
          'this is test',
          imageUrl:
              'https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png',
          data: {notificationKey: '[notification data]'},
          notificationSpecifics: NotificationSpecifics(
            AndroidNotificationSpecifics(
              autoCancelable: true,
            ),
          ),
        );
      });
}

final stompClient = StompClient(
  config: StompConfig(
      url:
          'ws://151.106.125.200:8888/websocket/delivery?access_token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfVVNFUiIsImV4cCI6MTYzODg5MTY2MH0.q90x5FnNB9dFsDFra4GU04tLfKvEV6ov3OltdXBR2NqAAvkRf9yEoLSsB_WcwN7_99vEWYBovXM5pHTnd_Fmng',
      onConnect: onConnect,
      onWebSocketError: (dynamic error) => print(error.toString()),
      onDisconnect: (StompFrame frame) => {flag = false},
      onDebugMessage: (String frame) => {print(frame)},
      onWebSocketDone: () => {print("onWebSocketDone")}),
);

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  notification = Notificator(
    onPermissionDecline: () {
      // ignore: avoid_print
      print('permission decline');
    },
    onNotificationTapCallback: (notificationData) {},
  )..requestPermissions(
      requestSoundPermission: true,
      requestAlertPermission: true,
    );
  stompClient.activate();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }
    if (event["action"] == "setAsForeground") {
      service.setForegroundMode(true);
    }
    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(false);
  FlutterBackgroundService().sendData({"action": "setAsBackground"});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterBackgroundService().sendData({"action": "setAsBackground"});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
