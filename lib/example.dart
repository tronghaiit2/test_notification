import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Flutter Code Sample';
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

bool flag = false;

void onConnect(StompFrame frame) {
  print("Connected");
  stompClient.subscribe(
    destination: '/user/queue/new-order',
    callback: (frame) {
      List<dynamic>? result = json.decode(frame.body!);
      print(result);
      flag = true;
      print(flag);
    },
  );
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
  stompClient.activate();
  runApp(MyApp());
}
