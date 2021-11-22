import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

bool flag = false;

void onConnect(StompFrame frame) {
  stompClient.subscribe(
    destination: '/user/queue/new-order',
    callback: (frame) {
      //List<dynamic>? result = json.decode(frame.body!);
      //print(result);
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

void main() {
  stompClient.activate();
}
