import 'dart:io';

/// Contains everything about a backend needed to display it in the UI and
/// connect to it.
class BackendInfo {
  final InternetAddress address;
  final String name;

  BackendInfo(this.address, this.name);

  @override
  String toString() {
    return 'BackendInfo{address: $address, name: $name}';
  }
}
