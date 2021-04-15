/// Contains offset data for pitch and roll.
class CalibrationData {
  final double offsetPitch;
  final double offsetRoll;

  CalibrationData(this.offsetPitch, this.offsetRoll);
}

/// Contains some roll and pitch data.
class PitchRollData {
  final double pitch;
  final double roll;

  PitchRollData(this.pitch, this.roll);

  /// Calibrates this data using the passed [CalibrationData].
  PitchRollData calibrated(CalibrationData calibrationData) {
    return PitchRollData(
        pitch - calibrationData.offsetPitch, roll - calibrationData.offsetRoll);
  }
}
