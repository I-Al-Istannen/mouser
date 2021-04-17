import 'package:flutter/foundation.dart';
import 'package:mouser/model/Sensors.dart';

class SensorState extends ChangeNotifier {
  CalibrationData _calibrationData;
  PitchRollData _pitchRollData;

  bool _detectedNod = false;

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

  bool get detectedNod => _detectedNod;

  set detectedNod(bool detected) {
    if(detected == _detectedNod) {
      return;
    }
    _detectedNod = detected;
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
