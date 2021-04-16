import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:mouser/model/EsenseUnit.dart';

enum SamplingResult { NotConnected, Started }
enum ConnectState {
  Connected,
  Connecting,
  DeviceFound,
  DeviceNotFound,
  Disconnected
}

/// Encapsulates communication with an eSense unit.
class ESenseCommunicator extends ChangeNotifier {
  StreamSubscription<SensorEvent> _sensorSubscription;
  final List<StreamSubscription<Object>> _openSubscriptions = [];
  final ESenseManager _manager = ESenseManager();

  ConnectState _connectionState = ConnectState.Disconnected;

  /// Returns the current connection state
  ConnectState get connectionState => _connectionState;

  ESenseCommunicator() {
    _init();
  }

  /// Connects to the device outlined in the given [configuration].
  Future<bool> connect(UnitConfiguration configuration) async {
    if (connectionState == ConnectState.Connecting) {
      return false;
    }

    _connectionState = ConnectState.Connecting;
    notifyListeners();

    return await _manager.connect("eSense-0115");
  }

  /// Starts sampling the eSense unit for data.
  Future<SamplingResult> startSampling(
      UnitConfiguration configuration, callback(SensorEvent event)) async {
    if (connectionState != ConnectState.Connected) {
      return SamplingResult.NotConnected;
    }

    await _manager.setSamplingRate(configuration.sampleRate);

    _sensorSubscription = _manager.sensorEvents.listen(callback);
    _openSubscriptions.add(_sensorSubscription);

    return SamplingResult.Started;
  }

  /// Stops sampling the eSense unit for data.
  void stopSampling() {
    if (_sensorSubscription != null) {
      _sensorSubscription.cancel();
      _openSubscriptions.remove(_sensorSubscription);
      _sensorSubscription = null;
    }
  }

  /// Disposes this manager, disconnecting from the handheld and ceasing all
  /// listen operations.
  Future<void> destroy() async {
    print("DESTROY");
    stopSampling();
    _openSubscriptions.forEach((element) {
      element.cancel();
    });
    _openSubscriptions.clear();

    if (connectionState != ConnectState.Disconnected) {
      await _manager.disconnect();
    }

    _connectionState = ConnectState.Disconnected;
    notifyListeners();
  }

  void _init() {
    _manager.connectionEvents.listen((event) {
      print(event);
      switch (event.type) {
        case ConnectionType.unknown:
          print(":(");
          break;
        case ConnectionType.connected:
          _connectionState = ConnectState.Connected;
          break;
        case ConnectionType.disconnected:
          _connectionState = ConnectState.Disconnected;
          break;
        case ConnectionType.device_found:
          _connectionState = ConnectState.DeviceFound;
          break;
        case ConnectionType.device_not_found:
          _connectionState = ConnectState.DeviceNotFound;
      }
      notifyListeners();
    });
  }
}
