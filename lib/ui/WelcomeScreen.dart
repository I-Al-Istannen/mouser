import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/EsenseUnit.dart';
import 'package:mouser/ui/SampleScreen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome!")),
      body: Center(child: Consumer<ApplicationState>(
        builder: (context, appState, child) {
          var elements = <Widget>[];
          elements.add(esenseInfo(appState.unitConfiguration, appState));

          if (appState.unitConfiguration != null &&
              appState.unitConfiguration.seemsValid()) {
            elements.add(Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SampleScreen()),
                    );
                  },
                  child: Text("Continue"),
                ),
              ),
            ));
          }

          return SingleChildScrollView(
            child: Column(
              children: elements,
            ),
          );
        },
      )),
    );
  }

  Widget esenseInfo(UnitConfiguration configuration, ApplicationState state) {
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
                subtitle: TextFormField(
                  initialValue:
                      configuration != null ? configuration.deviceName : null,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "eSense-XXXX",
                  ),
                  onFieldSubmitted: (value) => state.unitName = value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                minLeadingWidth: 10,
                leading: Icon(Icons.timer),
                title: Text("Sample rate"),
                subtitle: Slider(
                  min: 1,
                  max: 30,
                  value: configuration != null
                      ? configuration.sampleRate.toDouble()
                      : 1,
                  divisions: 30,
                  onChanged: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
