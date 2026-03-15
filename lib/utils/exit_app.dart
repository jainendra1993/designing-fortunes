import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'global_function.dart';

class ExitApp extends StatefulWidget {
  final Widget child;
  const ExitApp({super.key, required this.child});

  @override
  State<ExitApp> createState() => _ExitAppState();
}

class _ExitAppState extends State<ExitApp> {
  DateTime? _lastPressed;

  Future<bool> _onBackPressed() async {
    final now = DateTime.now();
    if (_lastPressed == null || now.difference(_lastPressed!) > Duration(seconds: 2)) {
      _lastPressed = now;
      ApGlobalFunctions.showCustomSnackbar(message: 'Press back again to exit', isSuccess: false);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await _onBackPressed();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}
