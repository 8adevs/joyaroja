import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// The single Start/Stop action on the home screen.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.isRunning,
    required this.onPressed,
  });

  final bool isRunning;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(isRunning ? 'home.stop_button'.tr() : 'home.start_button'.tr()),
    );
  }
}
