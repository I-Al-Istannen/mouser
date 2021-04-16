import 'package:flutter/foundation.dart';
import 'package:mouser/model/Backend.dart';
import 'package:mouser/model/EsenseUnit.dart';

/// Application-Global state.
class ApplicationState extends ChangeNotifier {
  UnitConfiguration _unitConfiguration = UnitConfiguration.empty();
  BackendInfo _backendInfo;

  /// The configuration of the active eSense unit. Might be null.
  UnitConfiguration get unitConfiguration => _unitConfiguration;

  /// Sets the used unit configuration
  set unitConfiguration(UnitConfiguration configuration) {
    this._unitConfiguration = configuration;
    notifyListeners();
  }

  /// Information about the used backend. Might be null.
  BackendInfo get backendInfo => _backendInfo;
}
