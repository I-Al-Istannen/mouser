import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/ui/BackendDataSender.dart';
import 'package:mouser/ui/ConnectStateDisplay.dart';
import 'package:mouser/ui/FloatingCalibrateButton.dart';
import 'package:mouser/ui/FloatingControlButton.dart';
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                      child: _buildOffsetDisplay(communicator),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
        child: Consumer2<ESenseCommunicator, SensorState>(
          builder: (context, communicator, state, child) {
            if (state.calibrationData == null &&
                communicator.connectionState == ConnectState.Connected) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingCalibrateButton(isPrimaryAction: true),
                  )
                ],
              );
            }

            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingControlButton(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingCalibrateButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOffsetDisplay(ESenseCommunicator communicator) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 224, 224, 224)),
              borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.rotateOrbit,
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Detected Rotation Preview",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: _buildOffsetDisplayInner(communicator),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffsetDisplayInner(ESenseCommunicator communicator) {
    if (communicator.samplingState == SamplingState.Sampling) {
      return Column(
        children: [OffsetDisplay(), BackendDataSender()],
      );
    }
    switch (communicator.connectionState) {
      case ConnectState.Connected:
        return Consumer<SensorState>(
          builder: (context, state, child) {
            if (state.calibrationData == null) {
              return Text("Calibrate your device with the button below.");
            }
            return Text(
              "Start sampling with the center button below or calibrate your"
              " setup with the button to the right.",
            );
          },
        );
      case ConnectState.Connecting:
      case ConnectState.DeviceFound:
        return Text("Please wait while the connection is established…");
      case ConnectState.DeviceNotFound:
      case ConnectState.Disconnected:
        return Text("Please connect using the button below :)");
    }
    throw Error();
  }
}
