import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/foundation.dart';
import 'package:mouser/math/PitchRollCalculator.dart';
import 'package:mouser/model/EsenseUnit.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/model/Sensors.dart';

enum SamplingResult { NotConnected, Started }
enum ConnectState {
  Connected,
  Connecting,
  DeviceFound,
  DeviceNotFound,
  Disconnected
}

enum SamplingState { NotSampling, Sampling, Calibrating }

/// Encapsulates communication with an eSense unit.
class ESenseCommunicator extends ChangeNotifier {
  StreamSubscription<SensorEvent> _sensorSubscription;
  final List<StreamSubscription<Object>> _openSubscriptions = [];
  final ESenseManager _manager = ESenseManager();

  SamplingState _samplingState = SamplingState.NotSampling;
  ConnectState _connectionState = ConnectState.Disconnected;

  int _calibrationRoundsCount = 0;
  int _calibrationRoundsLeft = 0;

  /// Return whether it is currently sampling data.
  SamplingState get samplingState => _samplingState;

  /// Returns the current connection state.
  ConnectState get connectionState => _connectionState;

  /// The amount of calibration rounds that are still missing
  int get calibrationRoundsLeft => _calibrationRoundsLeft;

  /// The total amount of calibration rounds to perform
  int get calibrationRoundsCount => _calibrationRoundsCount;

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
      UnitConfiguration configuration, SensorState sensorState) async {
    if (connectionState != ConnectState.Connected) {
      return SamplingResult.NotConnected;
    }

    await _manager.setSamplingRate(configuration.sampleRate);

    _sensorSubscription = _manager.sensorEvents.listen((event) {
      var accel = convertAccToG(event.accel);
      var gyro = convertGyroToDegPerSecond(event.gyro);

      if (sensorState.pitchRollData == null) {
        sensorState.pitchRollData = PitchRollData(0, 0);
      }

      var newData = adjustToSample(
        sensorState.pitchRollData,
        accel,
        gyro,
        configuration.sampleRate,
      );

      if (_calibrationRoundsLeft > 1) {
        _calibrationRoundsLeft--;

        sensorState.calibrationData = CalibrationData(
          sensorState.calibrationData.offsetPitch + newData.pitch,
          sensorState.calibrationData.offsetRoll + newData.roll,
        );

        notifyListeners();
      } else if (_calibrationRoundsLeft == 1) {
        _calibrationRoundsLeft--;

        sensorState.calibrationData = CalibrationData(
          sensorState.calibrationData.offsetPitch / _calibrationRoundsCount,
          sensorState.calibrationData.offsetRoll / _calibrationRoundsCount,
        );
        sensorState.pitchRollData = PitchRollData(0, 0);

        // And end it!
        stopSampling();
      } else {
        sensorState.pitchRollData = newData;
      }
    });
    _openSubscriptions.add(_sensorSubscription);

    if (_calibrationRoundsLeft <= 0) {
      _samplingState = SamplingState.Sampling;
    } else {
      _samplingState = SamplingState.Calibrating;
    }
    notifyListeners();

    return SamplingResult.Started;
  }

  /// Stops sampling the eSense unit for data.
  void stopSampling() {
    if (_sensorSubscription != null) {
      _sensorSubscription.cancel();
      _openSubscriptions.remove(_sensorSubscription);
      _sensorSubscription = null;
    }
    _samplingState = SamplingState.NotSampling;
    _calibrationRoundsLeft = 0;
    notifyListeners();
  }

  Future<SamplingResult> startCalibrating(
      UnitConfiguration configuration, SensorState sensorState) {
    _calibrationRoundsCount = configuration.sampleRate * 5;
    _calibrationRoundsLeft = _calibrationRoundsCount;
    sensorState.pitchRollData = PitchRollData(0, 0);
    sensorState.calibrationData = CalibrationData(0, 0);
    return startSampling(configuration, sensorState);
  }

  /// Disposes this manager, disconnecting from the handheld and ceasing all
  /// listen operations.
  Future<void> destroy() async {
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
          stopSampling();
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
