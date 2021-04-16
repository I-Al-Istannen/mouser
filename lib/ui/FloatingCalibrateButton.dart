import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/ui/CalibrationScreen.dart';
import 'package:provider/provider.dart';

class FloatingCalibrateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ESenseCommunicator>(
      builder: (context, communicator, child) {
        if (communicator.connectionState != ConnectState.Connected) {
          return Container();
        }
        if (communicator.samplingState == SamplingState.Sampling) {
          return Container();
        }

        return FloatingActionButton(
          heroTag: "calibrate",
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(MdiIcons.rulerSquareCompass),
          tooltip: "Start calibration",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CalibrationScreen()),
            );
          },
        );
      },
    );
  }
}
