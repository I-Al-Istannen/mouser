import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:provider/provider.dart';

class ConnectStateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ESenseCommunicator>(
      builder: (context, communicator, child) {
        var data = _connectStateLabels()[communicator.connectionState];

        return Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data["icon"], color: Colors.grey),
                Text(
                  data["text"],
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _connectStateLabels() {
    return {
      ConnectState.Connected: {
        "text": "Connected",
        "icon": MdiIcons.bluetoothConnect
      },
      ConnectState.Connecting: {
        "text": "Connecting...",
        "icon": MdiIcons.bluetooth
      },
      ConnectState.Disconnected: {
        "text": "Disconnected",
        "icon": MdiIcons.bluetoothOff
      },
      ConnectState.DeviceNotFound: {
        "text": "Device not found",
        "icon": MdiIcons.cellphoneOff
      },
      ConnectState.DeviceFound: {
        "text": "Device found",
        "icon": MdiIcons.cellphone
      },
    };
  }
}
