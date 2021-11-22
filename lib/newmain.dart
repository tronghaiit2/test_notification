import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notifications/example.dart';
import 'package:provider/provider.dart';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

bool flag = false;

void onConnect(StompFrame frame) {
  print("Connected");
  stompClient.subscribe(
    destination: '/user/queue/new-order',
    callback: (frame) {
      flag = true;
    },
  );
}

final stompClient = StompClient(
  config: StompConfig(
      url:
          'ws://151.106.125.200:8888/websocket/delivery?access_token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1dGgiOiJST0xFX0FETUlOLFJPTEVfVVNFUiIsImV4cCI6MTYzODg5MTY2MH0.q90x5FnNB9dFsDFra4GU04tLfKvEV6ov3OltdXBR2NqAAvkRf9yEoLSsB_WcwN7_99vEWYBovXM5pHTnd_Fmng',
      onConnect: onConnect,
      onWebSocketError: (dynamic error) => print(error.toString()),
      onDisconnect: (StompFrame frame) => {print("onDisconnect")},
      onDebugMessage: (String frame) => {print(frame)},
      onWebSocketDone: () => {print("onWebSocketDone")}),
);

class Person {
  final String name;
  final int initialAge;
  Person({required this.name, required this.initialAge});
  Stream<String> get age async* {
    var i = initialAge;
    while (i < 850) {
      await Future.delayed(Duration(seconds: 1), () {
        i++;
      });
      if (flag == true) {
        yield "co don hang moi";
        flag = false;
      } else {
        yield "ko co don";
      }
    }
  }
}

void main() {
  stompClient.activate();
  runApp(
    StreamProvider<String>(
      create: (_) => Person(name: 'Yohan', initialAge: 25).age,
      initialData: 25.toString(),
      catchError: (_, error) => error.toString(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Future Provider"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Consumer<String>(
            builder: (context, String age, child) {
              return Column(
                children: <Widget>[
                  Text("age: $age"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
