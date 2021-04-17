import 'package:flutter/material.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/model/Sensors.dart';
import 'package:provider/provider.dart';

class OffsetDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SensorState>(
      builder: (context, state, child) {
        if (state.calibratedPitchRollData == null) {
          return Center(
            child: Text("No data yet :/"),
          );
        }
        return SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _OffsetPainter(state.calibratedPitchRollData),
          ),
        );
      },
    );
  }
}

class _OffsetPainter extends CustomPainter {
  final PitchRollData pitchRollData;

  _OffsetPainter(this.pitchRollData);

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var moved = center.translate(-pitchRollData.roll, pitchRollData.pitch);
    canvas.drawLine(
      center,
      moved,
      Paint()..color = Colors.blueAccent,
    );
  }

  @override
  bool shouldRepaint(covariant _OffsetPainter oldDelegate) {
    return true;
  }
}
