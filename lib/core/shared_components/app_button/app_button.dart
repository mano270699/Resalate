import 'package:flutter/material.dart';

import 'models/app_button_model.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final AppButtonModel model;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: model.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: model.decoration,
        child: TextButton(
          style: model.buttonStyle,
          onPressed: onPressed,
          child: model.child,
        ),
      ),
    );
  }
}
