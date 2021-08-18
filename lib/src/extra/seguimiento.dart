import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Seguimiento extends StatefulWidget {
  Seguimiento({Key? key}) : super(key: key);

  @override
  _SeguimientoState createState() => _SeguimientoState();
}

class _SeguimientoState extends State<Seguimiento> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Seguimiento'),
      ),
      child: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            switch (orientation) {
              case Orientation.portrait:
                return _buildStepper(StepperType.vertical);
              case Orientation.landscape:
                return _buildStepper(StepperType.horizontal);
              default:
                throw UnimplementedError(orientation.toString());
            }
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: canContinue ? () => setState(() => ++currentStep) : null,
      steps: [
        for (var i = 0; i < 3; ++i)
          _buildStep(
            title: Text('Step ${i + 1}'),
            isActive: i == currentStep,
            state: i == currentStep
                ? StepState.editing
                : i < currentStep
                    ? StepState.complete
                    : StepState.indexed,
          ),
        _buildStep(
          title: Text('Error'),
          state: StepState.error,
        ),
        _buildStep(
          title: Text('Disabled'),
          state: StepState.disabled,
        )
      ],
    );
  }

  Step _buildStep(
      {required Widget title,
      StepState state = StepState.indexed,
      bool isActive = false}) {
    return Step(
      title: title,
      state: state,
      isActive: isActive,
      content: LimitedBox(
        maxWidth: 300,
        maxHeight: 300,
        child: Container(color: CupertinoColors.systemGrey),
      ),
    );
  }
}
