import 'package:flutter/material.dart';
import 'package:mouser/communication/BackendCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/Backend.dart';
import 'package:mouser/ui/SampleScreen.dart';
import 'package:provider/provider.dart';

class BackendConfigScreen extends StatefulWidget {
  @override
  _BackendConfigScreenState createState() => _BackendConfigScreenState();
}

class _BackendConfigScreenState extends State<BackendConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BackendCommunicator>(
      builder: (context, communicator, child) {
        communicator.startScanning();

        return Scaffold(
          appBar: AppBar(
            title: Text("Select a Computer"),
          ),
          body: Center(
            child: buildBackendList(communicator),
          ),
        );
      },
    );
  }

  Widget buildBackendList(BackendCommunicator communicator) {
    if (communicator.foundBackends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ListTile(
                title: Center(child: Text("It seems a bit empty around here")),
                subtitle: Center(child: Text("Scanning for Computers...")),
                trailing: CircularProgressIndicator(
                  value: null,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: communicator.foundBackends.length,
      itemBuilder: (context, index) =>
          buildBackendTile(communicator.foundBackends[index], communicator),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget buildBackendTile(
      BackendInfo backend, BackendCommunicator communicator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () {
          var state = Provider.of<ApplicationState>(context, listen: false);
          state.backendInfo = backend;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SampleScreen()),
          );
        },
        child: ListTile(
          visualDensity: VisualDensity(),
          title: Text(backend.name),
          subtitle: Text(backend.address.address),
        ),
      ),
    );
  }
}
