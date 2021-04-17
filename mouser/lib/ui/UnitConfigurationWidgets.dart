import 'package:flutter/material.dart';
import 'package:mouser/model/ApplicationState.dart';
import 'package:provider/provider.dart';

class DeviceNameInputField extends StatefulWidget {
  @override
  _DeviceNameInputFieldState createState() => _DeviceNameInputFieldState();
}

class _DeviceNameInputFieldState extends State<DeviceNameInputField> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, child) {
        _controller = TextEditingController(
          text: state.unitConfiguration.deviceName,
        );
        return TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _controller,
          decoration: InputDecoration(
            hintText: "eSense-XXXX",
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a value";
            }
            return null;
          },
          onFieldSubmitted: (value) =>
              state.unitConfiguration = state.unitConfiguration.withName(value),
        );
      },
    );
  }
}

class SampleRateInputSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, child) => Slider(
        min: 1,
        max: 30,
        divisions: 30,
        label: state.unitConfiguration.sampleRate.toString(),
        value: state.unitConfiguration.sampleRate.toDouble(),
        onChanged: (value) => state.unitConfiguration =
            state.unitConfiguration.withSampleRate(value.toInt()),
      ),
    );
  }
}
