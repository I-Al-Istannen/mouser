import 'dart:math';

import 'package:mouser/model/Sensors.dart';

/// Converts the raw accelerometer data to g.
List<double> convertAccToG(List<int> accel) {
  // Magic constant - Flutter esense DOES NOT expose the real data.
  // This is the default value.
  const double sensitivityFactor = 8192;

  List<double> data = [0, 0, 0];
  for (int i = 0; i < 3; i++) {
    data[i] = (accel[i] / sensitivityFactor);
  }

  return data;
}

/// Converts the raw gyroscope data to degress per second.
List<double> convertGyroToDegPerSecond(List<int> gyro) {
  // Magic constant - Flutter esense DOES NOT expose the real data.
  // This is the default value.
  const double sensitivityFactor = 65.5;

  List<double> data = [0, 0, 0];
  for (int i = 0; i < 3; i++) {
    data[i] = (gyro[i] / sensitivityFactor);
  }

  return data;
}

/// Takes historical data, a sampling rate and a new event and returns an
/// updated guess of the current pitch and roll.
PitchRollData adjustToSample(
    PitchRollData historical,
    List<double> accelDataInG,
    List<double> gyroDataInDegPerSecond,
    int samplingRate) {
  var gx = accelDataInG[1];
  var gy = -accelDataInG[0];
  var gz = accelDataInG[2];

  var length = sqrt(gx * gx + gy * gy + gz * gz);
  var normGx = gx / length;
  var normGy = gy / length;
  var normGz = gz / length;

  var pitch = -atan2(-normGx, sqrt(normGy * normGy + normGz * normGz));
  var roll = -atan2(normGz, normGy);

  pitch = pitch * 180 / pi;
  roll = roll * 180 / pi;

  var deltaT = 1.toDouble() / samplingRate;
  var alpha = 0.25;

  var newPitch =
      (historical.pitch + gyroDataInDegPerSecond[2] * deltaT) * alpha +
          pitch * (1 - alpha);
  var newRoll = (historical.roll + gyroDataInDegPerSecond[1] * deltaT) * alpha +
      roll * (1 - alpha);

  return PitchRollData(newPitch, newRoll);
}
