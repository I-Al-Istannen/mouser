import 'package:flutter/material.dart';
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OffsetDisplay(),
                        ),
                      ),
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
}
