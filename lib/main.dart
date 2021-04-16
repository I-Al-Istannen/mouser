import 'package:flutter/material.dart';
import 'package:mouser/communication/BackendCommunication.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/model/SensorState.dart';
import 'package:mouser/ui/BackendConfigScreen.dart';
import 'package:mouser/ui/WelcomeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ApplicationState()),
      ChangeNotifierProvider(create: (_) => ESenseCommunicator()),
      ChangeNotifierProvider(create: (_) => BackendCommunicator()),
      ChangeNotifierProvider(create: (_) => SensorState()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
