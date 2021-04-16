import 'package:flutter/material.dart';
import 'package:mouser/ui/UnitConfigurationWidgets.dart';

class ESenseConfigWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              trailing: Icon(Icons.bluetooth_audio),
              title: Text("E-Sense settings"),
              subtitle: Text("Configure your E-Sense unit"),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 16, 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                minLeadingWidth: 10,
                leading: Icon(Icons.edit),
                title: Text("Device name"),
                subtitle: DeviceNameInputField(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                minLeadingWidth: 10,
                leading: Icon(Icons.timer),
                title: Text("Sample rate"),
                subtitle: SampleRateInputSlider(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
