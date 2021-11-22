import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:push_notification/push_notification.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'HAINT Push Notifications';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: States(),
        ),
      ),
    );
  }
}

class States extends StatefulWidget {
  @override
  MyStatelessWidget createState() => MyStatelessWidget();
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

Stream<int> test() async* {
  yield* Stream.periodic(Duration(seconds: 1), makenumber);
}

int makenumber(int value) => (value + 1);

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

class MyStatelessWidget extends State<States> {
  String _bodyText = 'notification test';

  @override
  void initState() {
    super.initState();
    notification = Notificator(
      onPermissionDecline: () {
        // ignore: avoid_print
        print('permission decline');
      },
      onNotificationTapCallback: (notificationData) {
        setState(
          () {
            _bodyText = 'notification open: '
                '${notificationData[notificationKey].toString()}';
          },
        );
      },
    )..requestPermissions(
        requestSoundPermission: true,
        requestAlertPermission: true,
      );
    stompClient.activate();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: test(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && flag == true) {
          return Text('co dơn hang moi');
        }
        return Text(snapshot.data.toString());
      },
    );
  }
}

void main() {
  //stompClient.activate();
  runApp(MyApp());
}
