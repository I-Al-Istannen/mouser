import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/math/PitchRollCalculator.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/Sensors.dart';
import 'package:mouser/ui/OffsetDisplay.dart';
import 'package:provider/provider.dart';

class SampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sampling")),
      body: Consumer<ApplicationState>(
        builder: (context, appState, child) => Consumer<ESenseCommunicator>(
          builder: (context, communicator, child) {
            return WillPopScope(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildConnectionStatusWidget(communicator),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      buildConnectButton(communicator, appState),
                      buildStartSampleButton(communicator, appState),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OffsetDisplay(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async {
                await communicator.destroy();
                return true;
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildConnectButton(
      ESenseCommunicator communicator, ApplicationState appState) {
    if (communicator.connectionState == ConnectState.Disconnected) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: ElevatedButton(
          onPressed: () async {
            await communicator.connect(appState.unitConfiguration);
          },
          child: Text("Connect"),
        ),
      );
    }
    return Container();
  }

  Widget buildStartSampleButton(
      ESenseCommunicator communicator, ApplicationState appState) {
    if (communicator.connectionState == ConnectState.Connected) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: ElevatedButton(
          onPressed: () async {
            appState.calibrationData = CalibrationData(0, 0);
            appState.pitchRollData = PitchRollData(0, 0);

            await communicator.startSampling(
              appState.unitConfiguration,
              (event) {
                var accel = convertAccToG(event.accel);
                var gyro = convertGyroToDegPerSecond(event.gyro);
                var newData = adjustToSample(
                  appState.pitchRollData,
                  accel,
                  gyro,
                  appState.unitConfiguration.sampleRate,
                );

                appState.pitchRollData = newData;
              },
            );
          },
          child: Text("Start Sampling"),
        ),
      );
    }
    return Container();
  }

  Widget _buildConnectionStatusWidget(ESenseCommunicator communicator) {
    var data = connectStateLabels()[communicator.connectionState];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(data["icon"], color: Colors.grey),
        Text(
          data["text"],
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  connectStateLabels() {
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
