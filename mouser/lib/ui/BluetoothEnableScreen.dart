import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/BluetoothServices.dart';
import 'package:provider/provider.dart';

class BluetoothEnableScreen extends StatefulWidget {
  @override
  _BluetoothEnableScreenState createState() => _BluetoothEnableScreenState();
}

class _BluetoothEnableScreenState extends State<BluetoothEnableScreen> {
  bool calledPop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Settings"),
      ),
      body: Consumer<BluetoothServices>(
        builder: (context, bluetooth, child) {
          if (bluetooth.bothEnabled && !calledPop) {
            calledPop = true;
            Future.microtask(() => Navigator.pop(context));
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildBluetoothTile(bluetooth),
                SizedBox(height: 20),
                _buildLocationTile(bluetooth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBluetoothTile(BluetoothServices bluetooth) {
    var state = _bluetoothState(bluetooth.bluetoothEnabled);

    return _buildErrorTile(
      state["error"],
      ListTile(
        trailing: Icon(state["icon"]),
        title: Text("Bluetooth"),
        subtitle: Text(state["text"]),
      ),
    );
  }

  Widget _buildLocationTile(BluetoothServices bluetooth) {
    var state = _locationState(bluetooth.locationEnabled);

    var actionButtons = [];
    if (state["action"] != null) {
      actionButtons = [
        ElevatedButton(
          onPressed: () async => await state["action"](),
          child: Text("Open settings"),
        ),
      ];
    }

    return _buildErrorTile(
      state["error"],
      Column(
        children: [
          ListTile(
            trailing: Icon(state["icon"]),
            title: Text("Location services"),
            subtitle: Text(state["text"]),
          ),
          ...actionButtons
        ],
      ),
    );
  }

  Widget _buildErrorTile(bool error, Widget child) {
    var color;
    if (error) {
      color = Color.fromARGB(255, 197, 17, 98);
    } else {
      color = Color.fromARGB(255, 31, 170, 0);
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  _bluetoothState(ActivationState state) {
    switch (state) {
      case ActivationState.Unavailable:
        return {
          "icon": MdiIcons.bluetoothOff,
          "text": "Bluetooth is not supported on your device",
          "error": true
        };
      case ActivationState.Unauthorized:
        return {
          "icon": MdiIcons.bluetoothOff,
          "text": "Please grant this app Bluetooth permissions",
          "error": true
        };
      case ActivationState.Disabled:
        return {
          "icon": MdiIcons.bluetoothOff,
          "text": "Please enable Bluetooth",
          "error": true
        };
      case ActivationState.Enabled:
        return {
          "icon": MdiIcons.bluetooth,
          "text": "Bluetooth is enabled",
          "error": false
        };
    }
    throw Error();
  }

  _locationState(ActivationState state) {
    switch (state) {
      case ActivationState.Unavailable:
        return {
          "icon": MdiIcons.mapMarkerOff,
          "text": "Location services are not supported on your device",
          "error": true,
          "action": null
        };
      case ActivationState.Unauthorized:
        return {
          "icon": MdiIcons.mapMarkerOff,
          "text": "Please grant this app location permissions",
          "error": true,
          "action": () async => Geolocator.openAppSettings()
        };
      case ActivationState.Disabled:
        return {
          "icon": MdiIcons.mapMarkerOff,
          "text": "Please enable location services",
          "error": true,
          "action": () async => Geolocator.openLocationSettings()
        };
      case ActivationState.Enabled:
        return {
          "icon": MdiIcons.mapMarker,
          "text": "Location services are enabled",
          "error": false,
          "action": null
        };
    }
    throw Error();
  }
}
