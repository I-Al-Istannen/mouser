import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:mouser/model/EsenseUnit.dart';

enum ConnectionResult { ConnectTryFailed, Connected, Timeout, DeviceNotFound }
enum SamplingResult { NotConnected, Started }

/// Encapsulates communication with an eSense unit.
class ESenseCommunicator {
  StreamSubscription<SensorEvent> _sensorSubscription;
  final List<StreamSubscription<Object>> _openSubscriptions = [];
  final ESenseManager _manager = ESenseManager();

  Completer<ConnectionResult> _connectCompleter;

  /// Connects to the device outlined in the given [configuration].
  Future<ConnectionResult> connect(UnitConfiguration configuration) async {
    await dispose();

    var connectTryFailed = await _manager.connect(configuration.deviceName);

    if (connectTryFailed) {
      return ConnectionResult.ConnectTryFailed;
    }

    _init();

    return _connectCompleter.future.timeout(Duration(seconds: 15),
        onTimeout: () => ConnectionResult.Timeout);
  }

  /// Starts sampling the eSense unit for data.
  Future<SamplingResult> startSampling(
      UnitConfiguration configuration, callback(SensorEvent event)) async {
    if (!await _manager.isConnected()) {
      return SamplingResult.NotConnected;
    }

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
  Future<void> dispose() async {
    stopSampling();
    _openSubscriptions.forEach((element) {
      element.cancel();
    });
    _openSubscriptions.clear();

    if (await _manager.isConnected()) {
      await _manager.disconnect();
    }
  }

  void _init() {
    var subscription = _manager.connectionEvents.listen((event) {
      if (event.type == ConnectionType.connected) {
        _connectCompleter.complete(ConnectionResult.Connected);
      } else if (event.type == ConnectionType.device_not_found) {
        _connectCompleter.complete(ConnectionResult.DeviceNotFound);
      }
    });
    _openSubscriptions.add(subscription);
  }
}
