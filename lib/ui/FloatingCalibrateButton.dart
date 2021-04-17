import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/ui/CalibrationScreen.dart';
import 'package:provider/provider.dart';

class FloatingCalibrateButton extends StatelessWidget {
  final bool isPrimaryAction;

  const FloatingCalibrateButton({Key key, this.isPrimaryAction = false})
      : super(key: key);

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
          backgroundColor: isPrimaryAction ? null : Colors.white,
          foregroundColor: isPrimaryAction ? null : Colors.black,
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
