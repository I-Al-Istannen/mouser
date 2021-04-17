import 'package:flutter/foundation.dart';
import 'package:mouser/model/Sensors.dart';

class SensorState extends ChangeNotifier {
  CalibrationData _calibrationData;
  PitchRollData _pitchRollData;

  /// Returns the current calibration data. Might be null.
  CalibrationData get calibrationData => _calibrationData;

  set calibrationData(CalibrationData it) {
    this._calibrationData = it;
    notifyListeners();
  }

  /// Returns the current *uncalibrated* pitch and roll data.
  PitchRollData get pitchRollData => _pitchRollData;

  set pitchRollData(PitchRollData it) {
    this._pitchRollData = it;
    notifyListeners();
  }

  /// Returns the calibrated pitch and roll data, iff [pitchRollData] and
  /// [calibrationData are bot non-null.
  PitchRollData get calibratedPitchRollData {
    if (pitchRollData == null || calibrationData == null) {
      return null;
    }
    return pitchRollData.calibrated(calibrationData);
  }
}
