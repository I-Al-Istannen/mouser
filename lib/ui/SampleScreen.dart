import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/ui/ConnectStateDisplay.dart';
import 'package:mouser/ui/FloatingControlButton.dart';
import 'package:mouser/ui/OffsetDisplay.dart';
import 'package:provider/provider.dart';

class SampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sampling")),
      body: Consumer<ESenseCommunicator>(
        builder: (context, communicator, child) {
          return WillPopScope(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Column(
                  children: [
                    ConnectStateDisplay(),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                      child: _buildOffsetDisplay(communicator),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              await communicator.destroy();
              return true;
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingControlButton(),
    );
  }

  Widget _buildOffsetDisplay(ESenseCommunicator communicator) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 224, 224, 224)),
              borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MdiIcons.rotateOrbit),
                  SizedBox(width: 8),
                  Text(
                    "Detected Rotation Preview",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Center(
              child: _buildOffsetDisplayInner(communicator),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffsetDisplayInner(ESenseCommunicator communicator) {
    if(communicator.isSampling) {
      return OffsetDisplay();
    }
    switch(communicator.connectionState) {
      case ConnectState.Connected:
        return Text("Start sampling with the button below :)");
      case ConnectState.Connecting:
      case ConnectState.DeviceFound:
        return Text("Please wait while the connection is established…");
      case ConnectState.DeviceNotFound:
      case ConnectState.Disconnected:
        return Text("Please connect using the button below :)");
    }
    throw Error();
  }
}
