import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:provider/provider.dart';

class CalibrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calibration"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
            child: Card(
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
                        MdiIcons.rulerSquareCompass,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Calibration Instructions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1. Look straight ahead"),
                      SizedBox(height: 4),
                      Text("2. Press the 'Calibrate' button below"),
                      SizedBox(height: 4),
                      Text("3. Hold your position for a few seconds"),
                      SizedBox(height: 4),
                      Text("4. You are forwarded back to the sampling screen"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CalibrationButton(),
    );
  }
}

class _CalibrationButton extends StatefulWidget {
  @override
  __CalibrationButtonState createState() => __CalibrationButtonState();
}

class __CalibrationButtonState extends State<_CalibrationButton> {
  bool _hasCalledCalibrate = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ESenseCommunicator>(
      builder: (context, communicator, child) {
        if (communicator.samplingState == SamplingState.NotSampling &&
            _hasCalledCalibrate) {
          Future.microtask(() => Navigator.pop(context));
          return Container();
        }

        if(communicator.connectionState != ConnectState.Connected) {
          Future.microtask(() => Navigator.pop(context));
          return Container();
        }

        var isCalibrating =
            communicator.samplingState == SamplingState.Calibrating;

        if (isCalibrating) {
          var total = communicator.calibrationRoundsCount.toDouble();
          var left = communicator.calibrationRoundsLeft.toDouble();

          var progress = (total - left) / total;
          return FloatingActionButton(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: progress == 0 ? null : progress,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            ),
            onPressed: null,
          );
        }

        return FloatingActionButton(
          child: Icon(MdiIcons.rulerSquareCompass),
          onPressed: () async {
            var config = Provider.of<ApplicationState>(context, listen: false)
                .unitConfiguration;
            var sensorState = Provider.of<SensorState>(context, listen: false);

            if (communicator.samplingState == SamplingState.NotSampling) {
              _hasCalledCalibrate = true;
              await communicator.startCalibrating(config, sensorState);
            }
          },
        );
      },
    );
  }
}
