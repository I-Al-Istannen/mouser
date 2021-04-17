import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';

enum ActivationState { Unavailable, Unauthorized, Disabled, Enabled }

class BluetoothServices extends ChangeNotifier {
  ActivationState _bluetoothEnabled;

  ActivationState _locationEnabled;

  BluetoothServices() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      var enabled = await Geolocator.isLocationServiceEnabled();
      var allowed = await Geolocator.checkPermission();

      switch (allowed) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
          _locationEnabled = ActivationState.Unauthorized;
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          _locationEnabled =
              enabled ? ActivationState.Enabled : ActivationState.Disabled;
      }

      notifyListeners();
    });

    FlutterBlue.instance.state.listen((event) {
      switch (event) {
        case BluetoothState.unknown:
        case BluetoothState.unavailable:
          _bluetoothEnabled = ActivationState.Unavailable;
          break;
        case BluetoothState.unauthorized:
          _bluetoothEnabled = ActivationState.Unauthorized;
          break;
        case BluetoothState.on:
          _bluetoothEnabled = ActivationState.Enabled;
          break;
        case BluetoothState.turningOn:
        case BluetoothState.turningOff:
        case BluetoothState.off:
          _bluetoothEnabled = ActivationState.Disabled;
          break;
      }

      notifyListeners();
    });
  }

  /// Returns whether bluetooth is enabled on the device.
  ActivationState get bluetoothEnabled => _bluetoothEnabled;

  /// Returns whether location services are enabled on the device.
  ActivationState get locationEnabled => _locationEnabled;
}
