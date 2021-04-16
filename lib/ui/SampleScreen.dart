import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/math/PitchRollCalculator.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/model/Sensors.dart';
import 'package:mouser/ui/ConnectStateDisplay.dart';
import 'package:mouser/ui/OffsetDisplay.dart';
import 'package:provider/provider.dart';

class SampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sampling")),
      body: Consumer<ESenseCommunicator>(
        builder: (context, communicator, child) {
          return WillPopScope(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Column(
                  children: [
                    ConnectStateDisplay(),
                    SizedBox(
                      height: 30,
                    ),
                    buildConnectButton(communicator),
                    buildStartSampleButton(communicator),
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
    );
  }

  Widget buildConnectButton(ESenseCommunicator communicator) {
    if (communicator.connectionState == ConnectState.Disconnected) {
      return Consumer<ApplicationState>(
        builder: (context, appState, child) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: ElevatedButton(
            onPressed: () async {
              await communicator.connect(appState.unitConfiguration);
            },
            child: Text("Connect"),
          ),
        ),
      );
    }
    return Container();
  }

  Widget buildStartSampleButton(ESenseCommunicator communicator) {
    if (communicator.connectionState == ConnectState.Connected) {
      return Consumer2<SensorState, ApplicationState>(
        builder: (context, sensorState, appState, child) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: ElevatedButton(
            onPressed: () async {
              sensorState.calibrationData = CalibrationData(0, 0);
              sensorState.pitchRollData = PitchRollData(0, 0);

              await communicator.startSampling(
                appState.unitConfiguration,
                (event) {
                  var accel = convertAccToG(event.accel);
                  var gyro = convertGyroToDegPerSecond(event.gyro);
                  var newData = adjustToSample(
                    sensorState.pitchRollData,
                    accel,
                    gyro,
                    appState.unitConfiguration.sampleRate,
                  );

                  sensorState.pitchRollData = newData;
                },
              );
            },
            child: Text("Start Sampling"),
          ),
        ),
      );
    }
    return Container();
  }
}
