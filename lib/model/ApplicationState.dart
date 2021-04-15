import 'package:flutter/foundation.dart';
import 'package:mouser/model/Backend.dart';
import 'package:mouser/model/EsenseUnit.dart';
import 'package:mouser/model/Sensors.dart';

/// Application-Global state.
class ApplicationState extends ChangeNotifier {
  UnitConfiguration _unitConfiguration;
  BackendInfo _backendInfo;

  CalibrationData _calibrationData;
  PitchRollData _pitchRollData;

  /// The configuration of the active eSense unit. Might be null.
  UnitConfiguration get unitConfiguration => _unitConfiguration;

  set unitName(String name) {
    _unitConfiguration = UnitConfiguration(name, 1);
    notifyListeners();
  }

  /// Information about the used backend. Might be null.
  BackendInfo get backendInfo => _backendInfo;

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