import 'package:flutter/material.dart';
import 'package:mouser/ui/EsenseConfigWidget.dart';
import 'package:mouser/ui/SampleScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome!")),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ESenseConfigWidget(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SampleScreen()),
                        );
                      },
                      child: Text("Continue to sampling"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
