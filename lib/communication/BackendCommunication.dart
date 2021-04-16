import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mouser/model/Backend.dart';
import 'package:mouser/model/Sensors.dart';

class BackendCommunicator extends ChangeNotifier {
  List<BackendInfo> _foundBackends = [];

  /// Returns all backends this communicator has found so far.
  List<BackendInfo> get foundBackends => UnmodifiableListView(_foundBackends);

  RawDatagramSocket _socket;
  bool _connecting = false;

  /// Starts scanning for backends.
  Future<void> startScanning() async {
    if (_connecting) {
      return;
    }
    _connecting = true;

    await _initSocket();

    _socket.listen((event) {
      if (event == RawSocketEvent.read) {
        var datagram = _socket.receive();
        var address = datagram.address;
        var name = String.fromCharCodes(datagram.data);

        if (address == null) {
          return;
        }

        // We already know that one
        if (_foundBackends.any((backend) => backend.address == address)) {
          return;
        }

        _foundBackends.add(BackendInfo(address, name));
        notifyListeners();
      }
    });
  }

  Future<void> _initSocket() async {
    _socket = await RawDatagramSocket.bind("0.0.0.0", 13337);
  }

  /// Sends data to a given backend.
  Future<void> sendData(BackendInfo backendInfo, PitchRollData data) async {
    if (_socket == null) {
      await _initSocket();
    }
    var bytes = ByteData(2 * 8);
    bytes.setFloat64(0, data.pitch);
    bytes.setFloat64(8, data.roll);
    _socket.send(bytes.buffer.asInt8List(), backendInfo.address, 13338);
  }
}
