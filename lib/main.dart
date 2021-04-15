import 'package:flutter/material.dart';
import 'package:mouser/communication/ESenseCommunication.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:mouser/ui/WelcomeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ApplicationState()),
      ChangeNotifierProvider(create: (_) => ESenseCommunicator()),
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
