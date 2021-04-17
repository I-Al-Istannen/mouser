/// Configuration for an eSense unit.
class UnitConfiguration {
  final String deviceName;
  final int sampleRate;

  UnitConfiguration({this.deviceName, this.sampleRate = 1}) {
    if (sampleRate == null || sampleRate < 1 || sampleRate > 30) {
      throw Error();
    }
  }

  UnitConfiguration withName(String name) {
    return UnitConfiguration(deviceName: name, sampleRate: sampleRate);
  }

  UnitConfiguration withSampleRate(int rate) {
    return UnitConfiguration(deviceName: deviceName, sampleRate: rate);
  }

  factory UnitConfiguration.empty() {
    return UnitConfiguration(deviceName: null, sampleRate: 1);
  }
}
