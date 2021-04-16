import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/EsenseUnit.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/model/Sensors.dart';
import 'package:provider/provider.dart';

class FloatingControlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ESenseCommunicator, ApplicationState>(
      builder: (context, communicator, appState, child) {
        var sensorState = Provider.of<SensorState>(context, listen: false);
        var state =
        _state(communicator, appState.unitConfiguration, sensorState);

        return FloatingActionButton(
          child: Icon(state["icon"]),
          tooltip: state["tooltip"],
          onPressed: () {
            state["action"]();
          },
        );
      },
    );
  }

  _state(ESenseCommunicator communicator, UnitConfiguration configuration,
      SensorState sensorState) {
    var state = communicator.connectionState;
    var sampling = communicator.isSampling;

    if (sampling) {
      return {
        "icon": MdiIcons.timerOffOutline,
        "tooltip": "Stop sampling",
        "action": () => communicator.stopSampling()
      };
    }
    switch (state) {
      case ConnectState.Connected:
        return {
          "icon": MdiIcons.timerOutline,
          "tooltip": "Start sampling",
          "action": () {
            sensorState.calibrationData = CalibrationData(0, 0);
            sensorState.pitchRollData = PitchRollData(0, 0);

            communicator.startSampling(configuration, sensorState);
          }
        };
      case ConnectState.Connecting:
      case ConnectState.DeviceFound:
        return {
          "icon": MdiIcons.bluetoothOff,
          "tooltip": "Abort connection attempt",
          "action": () => communicator.destroy()
        };
      case ConnectState.DeviceNotFound:
      case ConnectState.Disconnected:
        return {
          "icon": MdiIcons.bluetooth,
          "tooltip": "Connect to earpiece",
          "action": () => communicator.connect(configuration)
        };
    }
  }
}
