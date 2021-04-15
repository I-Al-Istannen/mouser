import 'package:mouser/model/Backend.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class BackendConnection {
  final BackendInfo backendInfo;

  BackendConnection(this.backendInfo);

  run() async {
    while (true) {
      var channel = IOWebSocketChannel.connect(backendInfo.uri);

      channel.stream.listen((message) {
        channel.sink.add('received!');
        channel.sink.close(status.goingAway);
      });
    }
  }
}
