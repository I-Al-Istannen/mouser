import 'package:flutter/material.dart';
import 'package:mouser/communication/BackendCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:provider/provider.dart';

class BackendDataSender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ApplicationState, BackendCommunicator, SensorState>(
      builder: (context, appState, communicator, sensorState, child) {
        if (sensorState.detectedNod) {
          communicator.sendClick(appState.backendInfo);
        }

        if (sensorState.calibratedPitchRollData != null) {
          communicator.sendData(
            appState.backendInfo,
            sensorState.calibratedPitchRollData,
          );
        }

        return Container();
      },
    );
  }
}
