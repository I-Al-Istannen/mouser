/// Configuration for an eSense unit.
class UnitConfiguration {
  final String deviceName;
  final int sampleRate;

  UnitConfiguration(this.deviceName, this.sampleRate);

  bool seemsValid() {
    return sampleRate >= 1 &&
        sampleRate < 100 &&
        deviceName != null &&
        deviceName.isNotEmpty;
  }
}
