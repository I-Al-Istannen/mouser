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

        var progressChildren = [];

        if(data["progress"]) {
          progressChildren = [
            SizedBox(width: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 1,
              ),
            )
          ];
        }

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
                ),
                ...progressChildren
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
        "icon": MdiIcons.bluetoothConnect,
        "progress": false
      },
      ConnectState.Connecting: {
        "text": "Connecting",
        "icon": MdiIcons.bluetooth,
        "progress": true
      },
      ConnectState.Disconnected: {
        "text": "Disconnected",
        "icon": MdiIcons.bluetoothOff,
        "progress": false
      },
      ConnectState.DeviceNotFound: {
        "text": "Device not found",
        "icon": MdiIcons.cellphoneOff,
        "progress": false
      },
      ConnectState.DeviceFound: {
        "text": "Device found",
        "icon": MdiIcons.cellphone,
        "progress": true
      },
    };
  }
}
